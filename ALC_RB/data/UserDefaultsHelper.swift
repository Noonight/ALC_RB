//
//  UserDefaultsHelper.swift
//  ALC_RB
//
//  Created by ayur on 27.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    let userKey = "authUser"
    let userDefaults = UserDefaults.standard
    
    func userIsAuthorized() -> Bool {
        do {
//            let user = try self.userDefaults.get(objectType: AuthUser.self, forKey: userKey)
            let user = getAuthorizedUser()
//            Print.d(object: user)
            if user != nil {
                return true
            }
        } catch {
            print("Some error with getting user from UserDefaults")
        }
        return false
    }
    
    func getAuthorizedUser() -> AuthUser? {
        do {
//            guard let decoder = userDefaults.object(forKey: userKey) as? Data else { return nil }
//            let user = NSKeyedUnarchiver.unarchiveObject(with: decoder) as? AuthUser
//            let user = try self.userDefaults.get(objectType: AuthUser.self, forKey: userKey)
            
            return try userDefaults.get(objectType: AuthUser.self, forKey: userKey)
        } catch {
            print("Some error with getting user from UserDefaults")
        }
        return nil
    }
    
    func setAuthorizedUser(user: AuthUser) {
        do {
//            try userDefaults.set(object: user, forKey: userKey)
//            userDefaults.setValue(user, forKey: userKey)
            deleteAuthorizedUser()
            try userDefaults.set(object: user, forKey: userKey)
//            let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
//            userDefaults.set(encodedData, forKey: userKey)
        } catch {
            print("Somer error with setting user in UserDefaults")
        }
    }
    
    func deleteAuthorizedUser() {
        userDefaults.removeObject(forKey: userKey)
    }
    
    // DEPRECATED person does not contain participation matches
//    func setParticipationMatchPlayedBy(id: String) -> Bool {
//        guard var user = self.getAuthorizedUser() else { return false }
//
//
//        for i in 0...user.person.participationMatches!.count {
//            if user.person.participationMatches![i].isEqual({ $0.id == id }) {
//                user.person.participationMatches![i].map { match -> Match in
//                    var mMatch = match
//                    mMatch.played = true
//                    return mMatch
//                }
//                self.setAuthorizedUser(user: user)
//                return true
//            }
////        for i in 0...user.person.participationMatches!.count {
////            if user.person.participationMatches![i].id == id {
////                user.person.participationMatches![i].played = true
////                self.setAuthorizedUser(user: user)
////                return true
////            }
//        }
//        return false
//    }
    
//    func getToken() -> String {
//        return (self.getAuthorizedUser()?.token)!
//    }
    
    func getToken() -> String? {
        return self.getAuthorizedUser()?.token
    }
    
//    func setMatch(match: Match) {
//        var user = getAuthorizedUser()
//        user?.person.participationMatches?.removeAll(where: { $0.isEqual({ $0.id == match.id }) })
//        user?.person.participationMatches?.append(IdRefObjectWrapper<Match>(match))
//        setAuthorizedUser(user: user!)
//    }
    
}
