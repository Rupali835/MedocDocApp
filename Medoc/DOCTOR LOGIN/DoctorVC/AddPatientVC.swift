//
//  AddPatientVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import ZAlertView


protocol AddPatientProtocol {
    func callAddPatientApi()
}

class AddPatientVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btmfemale: UIButton!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var lblMan: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnDatePicker: UIButton!

    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var txtPatNm: SkyFloatingLabelTextField!
    @IBOutlet weak var txtContactNo: SkyFloatingLabelTextField!
    
    let date = Date()
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    var DateStr : String?
    var selectedImage: UIImage!
    var fileName: String!
    var m_caddPatient = AddPatient()
    var toast = JYToast()
    var m_dAddPatient : AddPatientProtocol!
    let formatter = DateFormatter()
    var dobStr : String!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      clearData()
        
      lblAge.isHidden = true
      imgMale.image = imgMale.image!.withRenderingMode(.alwaysTemplate)
      imgFemale.image = imgFemale.image!.withRenderingMode(.alwaysTemplate)
        
       self.txtContactNo.delegate = self
       self.txtPatNm.delegate = self
       self.txtDob.delegate = self
        
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        self.txtDate.text = stringDate
        self.DateStr = stringDate
        self.txtDate.delegate = self
       
         self.txtDob.addTarget(self, action: #selector(openDobPicker), for: .editingDidBegin)
        
        self.txtDate.addTarget(self, action: #selector(openPicker), for: .editingDidBegin)
        
        self.txtPatNm.addTarget(self, action: #selector(validName), for: .editingChanged)
        
        self.txtContactNo.addTarget(self, action: #selector(validContact), for: .editingChanged)
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        
        m_caddPatient.loggedin_id = dict["id"] as? Int
        m_caddPatient.loggedin_role = dict["role_id"] as? String
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    @objc func validContact()
    {
        if txtContactNo.text != nil {
            if let floatingLabelTextField = txtContactNo {
                
                
                if txtContactNo.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid Contact"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func validName()
    {
        if txtPatNm.text != nil {
            if let floatingLabelTextField = txtPatNm {
                
                
                if txtPatNm.text?.isValidName() == true
                {
                    floatingLabelTextField.errorMessage = "Invalid Name"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
        @objc func openPicker()
        {
            createDatePicker()
            
    }
    
    @objc func openDobPicker()
    {
        createDOB()
    }
    
     @IBAction func btnAddPatientProfile_onclick(_ sender: Any)
        {
           // self.TakePhoto()
           
            ImagePickerManager().pickImage(self){ image in
                //here is the image
                
                
                let timestamp = Date().toMillis()
                image.accessibilityIdentifier = String(describing: timestamp)
                
                self.fileName = String(describing: timestamp!)
                self.btnProfile.setImage(image, for: .normal)
                self.selectedImage = image
                
            }
            
         }
    
    
    
    func StringFromDate(nDate: Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: nDate)
    }
   
    func createDOB()
    {
        _ = Date()
        
//        let date = Date()
//        let datepicker = UIDatePicker()
//        let toolBar = UIToolbar()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDOB))
        
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelPicker))
        
        toolBar.setItems([barBtnItem, barBtnCancel], animated: false)
        txtDob.inputAccessoryView = toolBar
        txtDob.inputView = datepicker
    
        let calendar = Calendar.current
         let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = 01
        minDateComponent.month = 01
        minDateComponent.year = 1920
        
        let minDate = calendar.date(from: minDateComponent)
      
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        datepicker.minimumDate = minDate
        datepicker.maximumDate = maxDate
        
    }
    
    @objc func doneDOB()
    {
//        let date = Date()
//        let datepicker = UIDatePicker()
//        let toolBar = UIToolbar()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDob.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dobStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
        self.view.endEditing(true)
        let Age = calculateAge(dob: self.dobStr)
        lblAge.isHidden = false
        lblAge.text = "Age: \(Age)"
     
    }
    
    
    func createDatePicker()
    {
        _ = Date()
        
//        let date = Date()
//        let datepicker = UIDatePicker()
//        let toolBar = UIToolbar()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelPicker))
        
        toolBar.setItems([barBtnItem, barBtnCancel], animated: false)
        txtDate.inputAccessoryView = toolBar
        txtDate.inputView = datepicker
    
    }

    @objc func donePresses()
    {
//        let date = Date()
//        let datepicker = UIDatePicker()
//        let toolBar = UIToolbar()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDate.text = dateFormatter.string(from: datepicker.date)
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
    
    @IBAction func btnClosePopup_onClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    func clearData()
    {
        txtPatNm.text = ""
        txtContactNo.text = ""
        txtDob.text = ""
        lblAge.text = ""
    }
    
    
    @IBAction func btnSavePatData_onClick(_ sender: Any)
    {
        if validation()
        {
            TakePatientData()
        }
    }
    
    func validation() -> Bool
    {
        if txtPatNm.text == ""
        {
            self.toast.isShow("Patient name is mandatory")
            return false
        }
        
        if txtDob.text == ""
        {
            self.toast.isShow("Patient birth date is mandatory")
            return false
        }
        
        if txtContactNo.text == ""
        {
            self.toast.isShow("Contact Number is mandatory")
            return false
        }
        
        if txtContactNo.text != ""
        {
            if txtContactNo.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Contact", actiontitle: "Ok")
                {
                    print("")
                }
                return false
            }
            
        }
        return true
    }
    
    
    func TakePatientData()
    {
     
        if self.selectedImage != nil
        {
            m_caddPatient.profile_picture = self.fileName
        }else
        {
            m_caddPatient.profile_picture = "NF"
        }
        
        
         let PatApi = Constant.BaseUrl+Constant.addPatient
        
        let param = ["loggedin_id" : m_caddPatient.loggedin_id!,
                     "loggedin_role" : m_caddPatient.loggedin_role!,
                     "name" : txtPatNm.text!,
                     "gender" : m_caddPatient.gender!,
                     "contact" : txtContactNo.text!,
                     "profile_picture" : m_caddPatient.profile_picture!,
                     "action" : "new",
                     "dob" : self.dobStr!,
                     "appointment_date" : self.DateStr!] as [String : Any]
        
        print(param)
        Alamofire.request(PatApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.toast.isShow("Added successfully")
                    
                    self.m_dAddPatient.callAddPatientApi()
                    self.view.removeFromSuperview()
                    
                    let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PatientListVC") as! PatientListVC

                    self.AddFiles()

                        self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if Msg == "Phone number already registered"{
                    
                    ZAlertView.init(title: "Medoc", msg: "This contact number is already registered", actiontitle: "OK") {
                        print("")
                    }
                }else
                {
                    self.toast.isShow("Patient is not added")
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                self.view.removeFromSuperview()
             
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
                    let data = self.selectedImage.jpegData(compressionQuality: 0.1)
                    
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
                        if Msg == "success"
                        {
                             self.m_dAddPatient.callAddPatientApi()
                            self.view.removeFromSuperview()
                        }
                        if Msg == "fail"
                        {
                             self.m_dAddPatient.callAddPatientApi()
                          self.view.removeFromSuperview()
                        }
                        
                        if Msg == "Post Data Is Empty"
                        {
                             self.m_dAddPatient.callAddPatientApi()
                            self.view.removeFromSuperview()
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
 
 
    }
    
     @IBAction func btnmale_onclick(_ sender: Any)
     {
     btnmale.tag = 1
     m_caddPatient.gender = "1"
     self.lblMan.textColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
     self.imgMale.tintColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
     self.lblFemale.textColor = UIColor.darkGray
     self.imgFemale.tintColor = UIColor.darkGray
     }
     
     @IBAction func btnFemale_onclick(_ sender: Any)
     {
     btmfemale.tag = 2
     m_caddPatient.gender = "2"
     self.lblFemale.textColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
     self.imgFemale.tintColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
     self.lblMan.textColor = UIColor.darkGray
     self.imgMale.tintColor = UIColor.darkGray
     }
  
}
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
extension AddPatientVC : UITextFieldDelegate
{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == txtContactNo
        {
            guard let text = txtContactNo.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 10
        }
        return true
    }
}
