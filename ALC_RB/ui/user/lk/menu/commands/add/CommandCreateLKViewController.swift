//
//  CommandCreateLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 25.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandCreateLKViewController: BaseStateViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    let presenter = CommandCreateLKPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        saveBtn.image = saveBtn.image?.af_imageAspectScaled(toFit: CGSize(width: 22, height: 22))
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

extension CommandCreateLKViewController : CommandCreateLKView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
