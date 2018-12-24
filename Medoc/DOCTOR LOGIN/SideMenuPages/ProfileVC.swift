//
//  ProfileVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/18/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class ProfileVC: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var txtReferanceNo: HoshiTextField!
    @IBOutlet weak var txtDOB: HoshiTextField!
    @IBOutlet weak var txtAltMobNo: HoshiTextField!
    @IBOutlet weak var txtWebsite: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtSpecilizedIn: HoshiTextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var btnDoctorList: UIButton!
    @IBOutlet weak var btnMyAssistant: UIButton!
    
     let dropdownAssistantList = DropDown()
    let dropdownDoctorList = DropDown()
    var AssistantData = [AnyObject]()
    var DoctorDesigntnArr = [AnyObject]()
    var toast = JYToast()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.txtSpecilizedIn.delegate = self
        dropdownAssistantList.anchorView = btnMyAssistant
       
        dropdownDoctorList.anchorView = txtSpecilizedIn
        
        sideMenus()
        SetBtn()
        setDropDown()
        getAssistant()
        getDoctorDesintn()
    }
    
    func setDropDown()
    {
        dropdownAssistantList.direction = .bottom
        dropdownAssistantList.bottomOffset = CGPoint(x: 0, y: (dropdownAssistantList.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 25)
        
        dropdownDoctorList.direction = .top
        dropdownDoctorList.bottomOffset = CGPoint(x: 0, y: (dropdownDoctorList.anchorView?.plainView.bounds.height)!)
        
    }
    
    func SetBtn()
    {
        btnMyAssistant.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        
        btnDoctorList.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        
        btnDoctorList.layer.borderWidth = 1.0
        btnMyAssistant.layer.borderWidth = 1.0
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            backBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
 view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func setProfile()
    {
        let profileApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/update_doctor"
        
        let param = ["name" : "",
                     "email" : "",
                     "gender" : 1,   // 1= male, 2= female, 3= other
                     "contact_no" : "",
                     "alt_contact_no" : "",
                     "loggedin_id" : "2",
                     "registration_no" : "",
                     "qualification" : "",
                     "experience" : "",
                     "designation" : ""] as [String : Any]
        
        Alamofire.request(profileApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                
                if Msg == "success"
                {
                    let profileData = json["data"] as! [AnyObject]
                }
                
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func getAssistant()
    {
        let Api = "http://www.otgmart.com/medoc/medoc_new/index.php/API/get_assistant"
        let param = ["loggedin_role" : "5",
                     "loggedin_id" : "2"]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.AssistantData = json["data"] as! [AnyObject]
                    
                    for lcdict in self.AssistantData
                    {
                        let Name = lcdict["name"] as! String
                        self.dropdownAssistantList.dataSource.append(Name)
                    }
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
        
    }
    
    func getDoctorDesintn()
    {
        let DestApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/get_designations"
        
        Alamofire.request(DestApi, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.DoctorDesigntnArr = json["data"] as! [AnyObject]
                    
                    for lcData in self.DoctorDesigntnArr
                    {
                        let destnm = lcData["description"] as! String
                        self.dropdownDoctorList.dataSource.append(destnm)
                    }
                    
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropdownDoctorList.show()
        
        dropdownDoctorList.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtSpecilizedIn.text = item
            
            //self.btnFirst.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
        }
        
        
    }
    
    @IBAction func btnMyAssistant_onClick(_ sender: Any)
    {
        dropdownAssistantList.show()
    }
    
    @IBAction func brnBack_onClick(_ sender: Any)
    {
        if revealViewController() != nil
        {
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}
