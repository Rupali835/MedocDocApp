//
//  AddDoctorVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/18/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class AddAssistantVC: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    
    @IBOutlet weak var txtNm: HoshiTextField!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtExperience: HoshiTextField!
    @IBOutlet weak var txtQualification: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtemail: HoshiTextField!
    @IBOutlet weak var txtMobileNo: HoshiTextField!
    
    var toast = JYToast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
       
    }
    
    func AddAssistant()
    {
        if txtemail.text == ""
        {
            txtemail.text = "NF"
        }
        
        let addAssistantApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/add_assistant"
        
        let param = ["loggedin_id" : "2",
                     "loggedin_role" : "5",
                     "action" : "add",
                     "name" : txtNm.text!,
                     "email" : txtemail.text!,
                     "contact" : txtMobileNo.text!,
                     "hospital_id" : "1"
                     ]
        
        Alamofire.request(addAssistantApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                self.toast.isShow("Added successfully")
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func validation() -> Bool
    {
        if txtNm.text == ""
        {
            self.toast.isShow("Please enter name")
            return false
        }
        if txtMobileNo.text == ""
        {
            self.toast.isShow("Please enter mobile number")
            return false
        }
        if ((txtMobileNo.text?.count)! < 10) || ((txtMobileNo.text?.count)! > 10)
        {
            self.toast.isShow("Please enter valid mobile number")
            return false
        }
        return true
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @IBAction func btnBack_onClick(_ sender: Any)
    {
        if revealViewController() != nil
        {
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @IBAction func btnSend_onClick(_ sender: Any)
    {
        if validation()
        {
            AddAssistant()
        }
        
    }
    
}
