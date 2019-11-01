//
//  UpdateDoctorProfileVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/21/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Kingfisher

class UpdateDoctorProfileVC: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var txtWebsite: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtDob: HoshiTextField!
    @IBOutlet weak var txtSpecin: HoshiTextField!
    @IBOutlet weak var txtExperience: HoshiTextField!
    @IBOutlet weak var txtDesignation: HoshiTextField!
    @IBOutlet weak var txtQualification: HoshiTextField!
    @IBOutlet weak var txtRegisterNum: HoshiTextField!
    @IBOutlet weak var txtAltContact: HoshiTextField!
    @IBOutlet weak var txtContact: HoshiTextField!
    @IBOutlet weak var txtNm: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    
    var toast = JYToast()
    var DoctorDesigntnArr = [AnyObject]()
    let dropdownDoctorList = DropDown()
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String?
    var loggedinId : Int!
    
    var selectedImage: UIImage!
    var fileName: String!
    var m_cProfileData = [AnyObject]()
    var img_path = "http://medoc.co.in/medoc_doctor_api/uploads/"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtDesignation.delegate = self
        createDatePicker()
        dropdownDoctorList.anchorView = txtDesignation
        getDoctorDesintn()
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        
        loggedinId = dict["id"] as? Int
        setData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        dropdownDoctorList.show()
        dropdownDoctorList.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtDesignation.text = item
            print("Selected item: \(item) at index: \(index)")
            
        }
    }
    
    func getDoctorDesintn()
    {
       // let DestApi = "http://www.kanishkagroups.com/medoc_doctor_api/index.php/API/get_designations"
        
        let DestApi = Constant.BaseUrl + Constant.getDesignation
        Alamofire.request(DestApi, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.DoctorDesigntnArr = json["designations"] as! [AnyObject]
                    
                    for lcData in self.DoctorDesigntnArr
                    {
                        let destnm = lcData["designation"] as! String
                        self.dropdownDoctorList.dataSource.append(destnm)
                        let destId = lcData["id"] as! String
                    }
                    
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func UpdateProfile()
    {
        var ProfilePic = String()
        if self.selectedImage != nil
        {
            ProfilePic = self.fileName
        }else
        {
            ProfilePic = "NF"
        }
        var DateDob = String()
        if self.DateStr != nil
        {
            DateDob = self.DateStr!
        }else
        {
            DateDob = txtDob.text!
        }
        
      //  let profileApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/update_doctor"
        
        let profileApi = Constant.BaseUrl+Constant.setNewProfileData
        
        let Profile_param =
            [
            "name" : self.txtNm.text!,
            "email" : self.txtEmail.text!,
            "gender" : 1,   // 1= male, 2= female, 3= other
            "contact_no" : self.txtContact.text!,
            "alt_contact_no" : self.txtAltContact.text!,
            "loggedin_id" : self.loggedinId!,
            "registration_no" : self.txtRegisterNum.text!,
            "qualification" : self.txtQualification.text!,
            "experience" : self.txtExperience.text!,
            "specialized_in" : self.txtSpecin.text!,
            "dob" : DateDob,
            "website" : self.txtWebsite.text!,
            "address" : self.txtAddress.text!,
            "profile_picture" : ProfilePic,
            "designation" : "12"
            ] as! [String : Any]
        
      print(Profile_param)
        
        Alamofire.request(profileApi, method: .post, parameters: Profile_param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.AddFiles()
                }
                
                break
                
            case .failure(_):
                break
            }
        }
        
    }
    

    func AddFiles()
    {
       // let FileApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/add_files"
        
        let FileApi = Constant.BaseUrl+Constant.UploadFiles
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.selectedImage != nil
                {
                   // let data = self.selectedImage.pngData()
                    
                    let data = self.selectedImage.jpegData(compressionQuality: 0.0)
                    
                    multipartFormData.append(data!, withName: "images[]", fileName: self.fileName, mimeType: "images/jpeg")
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
                        
                        let Msg = JSON["msg"] as! String

                        var appstory = AppStoryboard.Doctor
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            appstory = AppStoryboard.Doctor
                        } else {
                            appstory = AppStoryboard.IphoneDoctor
                        }
                        
                        if Msg == "success"
                        {
                            let profilevc = appstory.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                            
                            self.present(profilevc, animated: true, completion: nil)
                            
                        }else if Msg == "fail"
                        {
                            self.toast.isShow("Image not uploaded")
                           let profilevc = appstory.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                                
                        self.present(profilevc, animated: true, completion: nil)
                            
                        }else
                        {
                             self.toast.isShow("Something went wrong")
                            let profilevc = appstory.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                            
                            self.present(profilevc, animated: true, completion: nil)
                        }
                        
                       
                        
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    
    
    
    @IBAction func btnCamera_onClick(_ sender: Any)
    {
        self.TakePhoto()
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnsave_onclick(_ sender: Any)
    {
        self.UpdateProfile()
    }
    
    func TakePhoto()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            for lcAttachment in CDBAttachmentArr
            {
                self.fileName = lcAttachment.fileName
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
                    
                    let timestamp = Date().toMillis()
                    image?.accessibilityIdentifier = String(describing: timestamp)
                    
                    self.fileName = String(describing: timestamp!)
                    self.btnProfile.setImage(image, for: .normal)
                 
                    self.selectedImage = image
                })
                
            }
            
        }, cancel: nil)
        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.capturedVideoQulity = UIImagePickerController.QualityType.typeHigh
        attachmentPickerController.allowsMultipleSelection = false
        attachmentPickerController.allowsSelectionFromOtherApps = false
        attachmentPickerController.present(on: self)
    }
    
    
    
    // MARK : DATAPICKER
    
    
    func StringFromDate(nDate: Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: nDate)
    }
    
    func createDatePicker()
    {
        _ = Date()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelPicker))
        
        toolBar.setItems([barBtnItem, barBtnCancel], animated: false)
        
        txtDob.inputAccessoryView = toolBar
        txtDob.inputView = datepicker
        
    }
    
    @objc func donePresses()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let txt = "Follow update"
        txtDob.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
        self.view.endEditing(true)
    }
    
    @objc func CancelPicker()
    {
        self.view.endEditing(true)
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    
    func setUpData(cProfileData: [AnyObject])
    {
        print("Data = \(cProfileData)")
       
        self.m_cProfileData = cProfileData
    }
    
    func setData()
    {
        for lcdata in m_cProfileData
        {
            self.txtNm.text = lcdata["name"] as? String
          //  self.txtDob.text = lcdata["dob"] as? String
            self.txtContact.text = lcdata["contact_no"] as? String
            self.txtAltContact.text = lcdata["alt_contact_no"] as? String
            self.txtEmail.text = lcdata["email"] as? String
            self.txtSpecin.text = lcdata["specialized_in"] as? String
            self.txtAddress.text = lcdata["address"] as? String
            self.txtWebsite.text = lcdata["website"] as? String
            self.txtExperience.text = lcdata["experience"] as? String
            self.txtDesignation.text = lcdata["designation"] as? String
            
            if let profilePic = lcdata["profile_picture"] as? String
            {
                
                let str = "\(img_path)\(profilePic)"
                let ImgUrl = URL(string: str)
                imgProfile.kf.setImage(with: ImgUrl)
                
            }
            
        }
    }
    
}
