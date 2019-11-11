//
//  ChangeProfileViewController.swift
//  ALC_RB
//
//  Created by ayur on 27.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var familyTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var patronymicTF: UITextField!
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var barSaveBtn: UIBarButtonItem!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let viewModel = EditProfileViewModel(dataManager: ApiRequests(), regionApi: RegionApi())
    var imagePicker: ImagePicker?
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorAction = {
            
        }
        emptyAction = {
            
        }
        
        setupImagePicker()
        setupBinds()
        
        viewModel.fetch()
        showAuthUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupNavBar()
    }
    
}

// MARK: - SETUP

extension EditProfileViewController {
    
    func setupImagePicker() {
        self.imageView.image = UIImage(named: "ic_add_photo")
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func setupBinds() {
        
        viewModel
            .regionViewModel
            .regions
            .bind(to: regionPicker.rx.itemTitles) { _, item in
                return "\(item.name)"
            }
            .disposed(by: bag)
        
        viewModel
            .regionViewModel
            .regions
            .subscribe({ elements in
                guard let regions = elements.element else { return }
                
                
                var index = 0
                var region: RegionMy?
                for i in 0..<regions.count {
                    if regions[i]._id == self.viewModel.authorizedUser?.person.region {
                        index = i
                        region = regions[i]
                    }
                }
                
                self.viewModel.regionViewModel.choosedRegion.accept(region)
                
                self.regionPicker.selectRow(index, inComponent: 0, animated: true)
            })
            .disposed(by: bag)
        
        regionPicker
            .rx
            .modelSelected(RegionMy.self)
            .subscribe({ event in
                guard let regions = event.element else { return }
                self.viewModel.regionViewModel.choosedRegion.accept(regions.first)
            })
            .disposed(by: bag)
        
        barSaveBtn
            .rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
                if self.fieldsIsEmpty() == false {
                    let birthdate = self.datePicker.date
                    let region = self.viewModel.regionViewModel.choosedRegion.value!._id
                    let profile = EditProfile(
                        name: self.nameTF.getTextOrEmptyString(),
                        surname: self.familyTF.getTextOrEmptyString(),
                        lastname: self.patronymicTF.getTextOrEmptyString(),
                        login: self.loginTF.text!,
                        _id: self.viewModel.authorizedUser!.person.id,
                        birthdate: birthdate,
                        region: region
                    )
                    self.viewModel.editProfile(profileInfo: profile)
                } else {
                    self.viewModel.message.onNext(SingleLineMessage(message: Constants.Texts.FILL_ALL_FIELDS))
                }
            })
            .disposed(by: bag)
        
        viewModel
            .choosedImage
            .observeOn(MainScheduler.instance)
            .subscribe({ element in
                guard let image = element.element else {
                    self.imageView.image = UIImage(named: "ic_add_photo")
                    return
                }
                self.imageView.image = image?.af_imageRoundedIntoCircle()
            })
            .disposed(by: bag)
        
        viewModel
            .editedPerson
            .asObserver()
            .subscribeOn(MainScheduler.instance)
            .subscribe({ uUser in
                guard let user = uUser.element else { return }
                self.showAuthUser()
            })
            .disposed(by: bag)
        
        viewModel.regionViewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(regionPicker.rx.loading)
            .disposed(by: bag)
        
        viewModel.regionViewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(regionPicker.rx.error)
            .disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
        
    }
    
    func setupNavBar() {
        navigationController?.isNavigationBarHidden = false
    }
    
}

// MARK: - ACTIONs

extension EditProfileViewController {
    
    @IBAction func onImagePressed(_ sender: UITapGestureRecognizer) {
        imagePicker?.present(from: self.view)
    }
    
}

// MARK: - HELPER

extension EditProfileViewController {
    
    func showAuthUser() {
        if let authUser = viewModel.authorizedUser {
            nameTF.text = authUser.person.name
            familyTF.text = authUser.person.surname
            patronymicTF.text = authUser.person.lastname
            loginTF.text = authUser.person.login
            
            datePicker.date = authUser.person.birthdate
            
            if let imagePath = authUser.person.photo {
                kfLoadImage(imagePath: imagePath) { result in
                    switch result {
                    case .success(let image):
                        self.viewModel.choosedImage.accept(image)
                    case .failure(let error):
                        self.viewModel.choosedImage.accept(nil)
                        Print.m("loading image failure \(error)")
                    }
                }
            }
        }
    }
    
    func fieldsIsEmpty() -> Bool {
        if nameTF.isEmpty() == true
            || familyTF.isEmpty() == true
            || patronymicTF.isEmpty() == true
            || loginTF.isEmpty() == true
            || viewModel.regionViewModel.choosedRegion.value == nil {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - IMAGE PICKER

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        viewModel.choosedImage.accept(image)
    }
}
