//
//  RegistrationViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Variables
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var familyTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var barCompleteButton: UIBarButtonItem!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        barCompleteButton.image =  barCompleteButton.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
    }
    
    // MARK: - Actions
    
    @IBAction func completeRegistration(_ sender: UIBarButtonItem) {
        print("complete registration button pressed")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
