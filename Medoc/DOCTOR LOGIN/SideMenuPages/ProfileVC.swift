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
import Kingfisher

class ProfileVC: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblNm: UILabel!
    @IBOutlet weak var txtReferanceNo: HoshiTextField!
    @IBOutlet weak var txtDOB: HoshiTextField!
    @IBOutlet weak var txtAltMobNo: HoshiTextField!
    @IBOutlet weak var txtWebsite: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtSpecilizedIn: HoshiTextField!
    @IBOutlet weak var backBtn: UIButton!
   
    
   var img_path = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/"
    let dropdownDoctorList = DropDown()
    var AssistantData = [AnyObject]()
    
    var toast = JYToast()
    var profileData = [AnyObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtSpecilizedIn.delegate = self
        dropdownDoctorList.anchorView = txtSpecilizedIn
        
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 1.0
    }
    
    func sideMenus()
    {
        
        if revealViewController() != nil {
            
            self.backBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        let LoginId = dict["id"] as! Int
        let Role = dict["role_id"] as! String
        GetDoctorProfile(Id: LoginId)
        sideMenus()
    }
    
     func GetDoctorProfile(Id : Int)
    {
        let get_profile = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_doctor_info"
        let param = ["loggedin_id" : Id]
        
        Alamofire.request(get_profile, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.profileData = json["data"] as! [AnyObject]
                    
                    for lcdata in self.profileData
                    {
                        self.lblNm.text = lcdata["name"] as! String
                        self.lblemail.text = lcdata["email"] as! String
                        self.lblContact.text = lcdata["contact_no"] as! String
                        
                        
                        if (lcdata["address"] as! String) != ""
                        {
                            self.txtAddress.text = (lcdata["address"] as! String)
                        }
                        
                        if (lcdata["website"] as! String) != ""
                        {
                            self.txtWebsite.text = (lcdata["website"] as! String)
                        }
                        
                        if (lcdata["dob"] as! String) != ""
                        {
                            self.txtDOB.text = (lcdata["dob"] as! String)
                        }
                        
                        if (lcdata["designation"] as! String) != ""
                        {
                            self.txtSpecilizedIn.text = (lcdata["designation"] as! String)
                        }
                        
                        if (lcdata["alt_contact_no"] as! String) != ""
                        {
                            self.txtAltMobNo.text = (lcdata["alt_contact_no"] as! String)
                        }
                        
                        if (lcdata["registration_no"] as! String) != ""
                        {
                            self.txtReferanceNo.text = (lcdata["registration_no"] as! String)
                        }

                        if let profile_img = lcdata["profile_picture"] as? String
                        {
                            let str = "\(self.img_path)\(profile_img)"
                            let ImgUrl = URL(string: str)
                            self.imgProfile.kf.setImage(with: ImgUrl)
                        }
                        
                    }
                }
                
                
                break
                
            case .failure(_):
                break
            }
            
        }
    }
    
  
    
    @IBAction func brnBack_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEditProfile_onclick(_ sender: Any)
    {
        let updateVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "UpdateDoctorProfileVC") as! UpdateDoctorProfileVC
        updateVc.setUpData(cProfileData: self.profileData)
        self.present(updateVc, animated: true, completion: nil)
    }
    
}
