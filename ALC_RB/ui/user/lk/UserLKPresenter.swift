//
//  UserLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UserLKView: MvpView {
    
    func onRefreshUserSuccessful(authUser: AuthUser)
    func onRefreshUserFailure(authUser: Error)
}

class UserLKPresenter: MvpPresenter<UserLKViewController> {
    
    private let personApi = PersonApi()
    private let leagueApi = LeagueApi()
    private let matchApi = MatchApi()
    
    var menuItems: Observable<[MenuGroupModel]> {
        return Observable.combineLatest(leagues, matches) { l, m in
            Print.m("COMBINE LATEST")
            if l.count != 0 && m.count != 0 {
                return [
                    MenuGroupModel(title: "Игрок", items: [.invites, .tourneys, .teams]),
                    MenuGroupModel(title: "Судья", items: [.schedule, .myMatches]),
                    MenuGroupModel(title: "Выход", items: [.signOut])
                ]
            }
            if l.count != 0 {
                return [
                    MenuGroupModel(title: "Игрок", items: [.invites, .tourneys, .teams]),
                    MenuGroupModel(title: "Судья", items: [.schedule]),
                    MenuGroupModel(title: "Выход", items: [.signOut])
                ]
            }
            if m.count != 0 {
                return [
                    MenuGroupModel(title: "Игрок", items: [.invites, .tourneys, .teams]),
                    MenuGroupModel(title: "Судья", items: [.myMatches]),
                    MenuGroupModel(title: "Выход", items: [.signOut])
                ]
            }
            return [
                MenuGroupModel(title: "Игрок", items: [.invites, .tourneys, .teams]),
                MenuGroupModel(title: "Выход", items: [.signOut])
            ]
        }
    }
    let leagues = PublishSubject<[League]>()
    let matches = PublishSubject<[Match]>()
    
    func fetch() {
        self.fetchMainRefLeagues()
        self.fetchMyMatches()
    }
    
    func refreshUser(token: String) {
        personApi.get_refreshAuthUser(token: token) { result in
            switch result {
            case .success(let authUser):
                self.getView().onRefreshUserSuccessful(authUser: authUser)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onRefreshUserFailure(authUser: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func fetchMainRefLeagues() {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .status, value: StrBuilder().setSeparatorStyle(.comma).add(.comma).add([League.Status.pending.rawValue, League.Status.started.rawValue]))
            .add(key: .mainReferee, value: userId)
            .select(.mainReferee)
            .get()
        leagueApi.get_league(params: params) { result in
            switch result {
            case .success(let leagues):
                Print.m(leagues)
                self.leagues.onNext(leagues)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func fetchMyMatches() {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return }
        let params = ParamBuilder<Match.CodingKeys>()
            .add(key: "referees.person", value: userId)
            .select("referees.person referees._id")
            .get()
        matchApi.get_match(params: params) { result in
            switch result {
            case .success(let matches):
                self.matches.onNext(matches)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
}
