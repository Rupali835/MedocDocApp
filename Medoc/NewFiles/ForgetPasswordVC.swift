//
//  ForgetPasswordVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/17/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import ZAlertView

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtConformPassword: HoshiTextField!
    @IBOutlet weak var txtNewPassword: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var btnLoginBack: UIButton!
    
    var m_cContainerVC: ContainerVC!
    var toast = JYToast()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSubmit.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
        

    }
    
    func initilize(cContainervc: ContainerVC)
    {
        self.m_cContainerVC = cContainervc
    }
    
    @IBAction func btnLoginBack_onClick(_ sender: Any)
    {
       self.view.removeFromSuperview()
    }
    
    @IBAction func btnSubmit_onClick(_ sender: Any)
    {
        
    }
    
    func validation() -> Bool
    {
        if txtEmail.text == "" && txtNewPassword.text == "" && txtConformPassword.text == ""
        {
            self.toast.isShow("Both field ara mandetory")
            return false
        }
        if txtEmail.text == "" || txtNewPassword.text == "" || txtConformPassword.text == ""
        {
            self.toast.isShow("Both field ara mandetory")
            return false
        }
        
        if txtNewPassword.text?.isValidPassword() == false
        {
            ZAlertView.init(title: "Medoc", msg: "You should enter Minimum eight and maximum 10 characters, at least one uppercase letter, one lowercase letter, one number and one special character", actiontitle: "OK") {
                
            }
              return false
        }
        
        if txtNewPassword.text != txtConformPassword.text
        {
            self.toast.isShow("Your New password and confirm password should be same")
            return false
        }
        
        return true
    }
    
}
