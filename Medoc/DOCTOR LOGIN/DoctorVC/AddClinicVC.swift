//
//  AddClinicVC.swift
//  Medoc
//
//  Created by Rupali Patil on 15/05/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import ZAlertView
import Alamofire

protocol AddClinicProtocol {
    func addClinicInprofile()
}


class ClinicData : Decodable
{
    var h_name : String!
    var h_address : String!
    var h_contact : String!
    var h_website : String!
    var h_email : String!
    var h_pincode : String!
    var loggedin_id : Int!
    var loggedin_role : String!
    var h_logo : String!
}

class ClinicLogo
{
    var clinicName : String!
    var clinicImg : UIImage!
    
    init(cName: String, cImage: UIImage)
    {
        self.clinicName = cName
        self.clinicImg = cImage
    }
}

class AddClinicVC: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtaddrs: UITextField!

    @IBOutlet weak var loader: DotsLoader!
    
    var toast = JYToast()
    var m_cClinicData = ClinicData()
    var selectedImage: UIImage!
    var fileName: String!
    var imagePicker = UIImagePickerController()
    var m_cClinicLogo = [ClinicLogo]()
    var hospialAddedKey : Bool!
    var delegate : AddClinicProtocol!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setLayout(textLayout: [txtName, txtaddrs, txtContact, txtWebsite, txtEmail])
        fieldView.layer.borderWidth = 1.0
        fieldView.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor

        fieldView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)

        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary

        m_cClinicData.loggedin_id = dict["id"] as? Int
        m_cClinicData.loggedin_role = dict["role_id"] as? String
        
        self.hospialAddedKey = (dict["hospital_added"] as! Bool)
        self.loader.isHidden = true
    }

    func setDelegate()
    {
        txtName.delegate = self
        txtaddrs.delegate = self
        txtEmail.delegate = self
        txtContact.delegate = self
    }
    
    func setLayout(textLayout : [UITextField])
    {
       // let paddingView : UIView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        
        for item in textLayout
        {
            item.layer.cornerRadius = 35.0
            item.layer.borderWidth = 1.0
            item.layer.borderColor = UIColor.black.cgColor
           
        }
    }
    
    @IBAction func btnCancel_onclick(_ sender: Any)
    {
        if self.hospialAddedKey == true{
            self.dismiss(animated: true, completion: nil)
        }else
        {
            ZAlertView.init(title: "MeDoc", msg: "If you are not filling the clinic information, You will not able to give prescription to patient.", actiontitle: "OK")
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
  
    @IBAction func btnSubmit_onclick(_ sender: Any)
    {
        if valid()
        {
            addClinic()
        }
    }
    
    func valid() -> Bool
    {
        if txtName.text == ""
        {
            self.txtName.layer.borderColor = UIColor.red.cgColor
            self.txtName.placeholder = "Enter Clinic Name"
            return false
        }else
        {
             self.txtName.layer.borderColor = UIColor.black.cgColor
        }
        if txtaddrs.text == ""
        {
            self.txtaddrs.layer.borderColor = UIColor.red.cgColor
            self.txtaddrs.placeholder = "Enter Clinic Address"
            return false
        }else
        {
             self.txtaddrs.layer.borderColor = UIColor.black.cgColor
        }
        if txtContact.text == ""
        {
            self.txtContact.layer.borderColor = UIColor.red.cgColor
            self.txtContact.placeholder = "Enter Contact Number"
            return false
        }
        return true
    }
    
    func addClinic()
    {
        if self.m_cClinicLogo.count != 0
        {
            for img in self.m_cClinicLogo
            {
              m_cClinicData.h_logo = img.clinicName
            }
        }else
        {
              m_cClinicData.h_logo = "NF"
        }
        
        let Api = Constant.BaseUrl + Constant.addClinic
        let param = ["h_name" : txtName.text!,
                     "h_address" : txtaddrs.text!,
                     "h_contact" : txtContact.text!,
                     "h_website" : txtWebsite.text!,
                     "h_email" : txtEmail.text!,
                     "h_pincode" : "NF",
                     "loggedin_id" : m_cClinicData.loggedin_id!,
                     "loggedin_role" : m_cClinicData.loggedin_role!,
                     "action" : "add",
                     "h_logo" : m_cClinicData.h_logo!
            ] as [String : Any]
        print(param)
//        self.loader.isHidden = false
//        self.loader.startAnimating()
        
          self.view.activityStartAnimating(activityColor: UIColor.black, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let msg = json["msg"] as! String
                if msg == "success"
                {
                    if self.m_cClinicData.h_logo != "NF"
                    {
                        self.addLogoFile()
                    }else
                    {
                          self.view.activityStopAnimating()
                        ZAlertView.init(title: "MeDoc", msg: "Clinic is added successfully.", actiontitle: "OK")
                        {
                            self.delegate.addClinicInprofile()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                   
                }
                break
                
            case .failure(_):
                self.view.activityStopAnimating()
                Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Something went wrong. Check internet connection.")
                break
                
            }
            
        }
        
    }
    
    func addLogoFile()
    {
       
        let FileApi = Constant.BaseUrl + Constant.UploadFiles
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                
                if self.m_cClinicLogo.count != 0
                {
                    for img in self.m_cClinicLogo
                    {
                        let logoImg = img.clinicImg
                        let data = logoImg?.jpegData(compressionQuality: 0.0)
                       multipartFormData.append(data!, withName: "images[]", fileName: img.clinicName, mimeType: "images/jpeg")
                    }
                }
                
            },
            
            usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
            to : FileApi,
            method: .post)
            
        { (result) in
            
            print(result)
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value as? [String: Any] {
                        print("Response : ",JSON)
                        
                       self.view.activityStopAnimating()
                        
//                        self.loader.stopAnimating()
//                        self.loader.isHidden = true
                        
                        let Msg = JSON["msg"] as! String
                        if Msg == "success"
                        {
                            ZAlertView.init(title: "MeDoc", msg: "Clinic is added successfully.", actiontitle: "OK")
                            {
                            self.delegate.addClinicInprofile()
                             self.dismiss(animated: true, completion: nil)
                            }
                        }
                        if Msg == "fail"
                        {
                           self.toast.isShow("image not upload")
                            ZAlertView.init(title: "MeDoc", msg: "Clinic is added successfully.", actiontitle: "OK")
                            {
                            self.delegate.addClinicInprofile()
                            self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        if Msg == "Post Data Is Empty"
                        {
                            self.toast.isShow("image not upload")
                            self.delegate.addClinicInprofile()

                              self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Something went wrong. Internet connection appears off.")
            }
            
        }
        
    }
    
    @IBAction func btnLogo_onClick(_ sender: Any)
    {
        ImagePickerManager().pickImage(self){ image in
            
            let timestamp = Date().toMillis()
            image.accessibilityIdentifier = String(describing: timestamp)
            
            self.fileName = String(describing: timestamp!) + ".jpeg"
            self.imgLogo.image = image
            self.selectedImage = image
            
            let cLogo = ClinicLogo(cName: self.fileName, cImage: self.selectedImage)
            self.m_cClinicLogo.append(cLogo)
        }
    }
    
    
}
extension AddClinicVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
    
        switch textField
        {
        case txtName:
            txtName.layer.borderColor = UIColor.black.cgColor
            break
        
        case txtaddrs:
            txtaddrs.layer.borderColor = UIColor.black.cgColor
            break
        
        case txtContact:
            break
          
        default:
            print("")
        }
        return true
    }
}
