//
//  ForgetPasswordVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/17/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import ZAlertView
import Alamofire

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var loader: DotsLoader!
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
    
    override func viewWillAppear(_ animated: Bool) {
          self.txtEmail.text = ""
        self.loader.isHidden = true
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
        self.view.endEditing(true)
        
       if valid()
       {
         loader.isHidden = false
         loader.startAnimating()
        
        
          let Api = Constant.BaseUrl + Constant.ForgotPassword
          let param = ["username" : txtEmail.text!]
          Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            self.loader.stopAnimating()
            self.loader.isHidden = true
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details in Medoc App. Thank you!", actiontitle: "OK")
                    {
                        self.view.removeFromSuperview()
                    }
                }
                if Msg == "fail"
                {
                    ZAlertView.init(title: "Medoc", msg: "Your data is not found, Please sign up.", actiontitle: "OK")
                    {
                        self.view.removeFromSuperview()
                    }
                }
                break
                
            case .failure(_):
                break
            }
            
        }
        }
    }
 
    func valid() -> Bool
    {
        if txtEmail.text == ""
        {
            self.toast.isShow("Email ID is mandetory")
            return false
        }
        return true
    }
    
    /*
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
   */
}
