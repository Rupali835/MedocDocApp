
import UIKit
import Alamofire
import ZAlertView
import CloudTagView
import DropDown
import SkyFloatingLabelTextField

class SignUpFormVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var imgview: UIView!
    @IBOutlet weak var imgpic: UIImageView!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtQualification: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRegNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
   
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var QualificationtagView: CloudTagView!
    
    var imagePicker = UIImagePickerController()
    var m_cContainerVC: ContainerVC!
    var toast = JYToast()
    var selectedImage: UIImage!
    var fileName: String!
    var dropdownQualification = DropDown()
    var selectQualificationString = [String]()
    var m_cFilterdArr = [String]()
   // var m_csignVc = SignUpFormVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownQualification.anchorView = txtQualification
        txtQualification.delegate = self
        btnRegister.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)

        QualificationtagView.delegate = self
        AddJsonData()
        textValidAction()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        txtName.text = ""
        txtEmail.text = ""
        txtMobileNo.text = ""
        txtRegNo.text = ""
        txtQualification.text = ""
        selectQualificationString = []
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnProfileImg.layer.cornerRadius = 110.0
        imgpic.layer.cornerRadius = 110.0
        imgview.layer.cornerRadius = 110.0
        btnProfileImg.clipsToBounds = true
    }
    
    func textValidAction()
    {
        self.txtEmail.delegate = self
        self.txtMobileNo.delegate = self
        
        self.txtMobileNo.addTarget(self, action: #selector(MobileNoDidChange), for: .editingChanged)
        self.txtEmail.addTarget(self, action: #selector(EmailDidChande), for: .editingChanged)
        
    }

    
    @objc func MobileNoDidChange()
    {
        if txtMobileNo.text != nil {
            if let floatingLabelTextField = txtMobileNo {
                
                
                if txtMobileNo.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid contact number"
                }
                else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func EmailDidChande()
    {
        if txtEmail.text != nil {
            if let floatingLabelTextField = txtEmail {
                
                
                if txtEmail.text?.isValidEmail() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    func AddJsonData()
    {
       let doctApi = Constant.BaseUrl+Constant.TypesOfDoctor
        
        Alamofire.request(doctApi, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    let Data = json["data"] as! [AnyObject]
                    for lcdict in Data
                    {
                      let Name = lcdict["name"] as? String
                    self.dropdownQualification.dataSource.append(Name!)
                        
                    }
                }
                break
                
            case .failure(_):
                
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func initilize(cContainervc: ContainerVC)
    {
       self.m_cContainerVC = cContainervc
    }
  
    @IBAction func btnCloseSignUPpage_onClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }

    @IBAction func btnRegister_onClick(_ sender: Any)
    {
       self.view.endEditing(true)
       if validation()
       {
          sendData()
       }
    }
   
    @IBAction func btnCamera_onClick(_ sender: Any)
    {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            
            let timestamp = Date().toMillis()
            image.accessibilityIdentifier = String(describing: timestamp)
            
            self.fileName = String(describing: timestamp!) + ".jpeg"
            self.btnProfileImg.setImage(image, for: .normal)
            
            self.selectedImage = image
            
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    // MARK : FUNCTIONS
    
    func sendData()
    {
        var ProfilePic = String()
        
        var QualVal = String()
        
        if selectQualificationString.isEmpty == true
        {
            QualVal = "NF"
        }else
        {
            QualVal = json(from: selectQualificationString)!
        }
    
        if self.selectedImage != nil
        {
            ProfilePic = self.fileName
        }else{
             ProfilePic = "NF"
        }
        
        let SignupApi = Constant.BaseUrl + Constant.SignIn
        
        let param = ["name" : txtName.text!,
                     "email" : txtEmail.text!,
                     "contact_no" : txtMobileNo.text! ,
                     "qualification" : QualVal,
                     "registration_no" : txtRegNo.text!,
                     "profile_picture" : ProfilePic
                     
            ] as Parameters
        
        print(param)
       
          self.view.activityStartAnimating(activityColor: UIColor.black, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
        Alamofire.request(SignupApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    if ProfilePic != "NF"
                    {
                        self.AddFiles()
                    }else
                    {
                        self.view.activityStopAnimating()
                        ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details for login in Medoc App. Thank you!", actiontitle: "OK")
                        {
                            self.view.removeFromSuperview()
                        }
                    }
                }
                if Msg == "Fail"
                {
                    let Error = json["error"] as! String
                    ZAlertView.init(title: "Medoc", msg: Error, actiontitle: "OK")
                    {
                    }
                }
                  self.view.activityStopAnimating()
                break
            case .failure(_):
                self.view.activityStopAnimating()
                Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Somthing went wrong. Please check internet connection")
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
                    
 self.view.activityStopAnimating()
                    
                    if let JSON = response.result.value as? [String: Any] {
                        print("Response : ",JSON)
                        
                        let Msg = JSON["msg"] as! String
                        if Msg == "success"
                        {
                            ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details in Medoc App. Thank you!", actiontitle: "OK")
                            {
                                self.view.removeFromSuperview()
                            }
                        }
                        if Msg == "Fail"
                        {
                            ZAlertView.init(title: "Medoc", msg: "Mobile number or Email has already available on server. Please use another.", actiontitle: "OK")
                            {
                            }
                        }
                        
                        if Msg == "fail"
                        {
                            ZAlertView.init(title: "Medoc", msg: "Something went wrong, Try after sometime", actiontitle: "OK")
                            {
                               // self.view.removeFromSuperview()
                            }
                        }
                        
                        if Msg == "Post Data Is Empty"
                        {
                            ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details in Medoc App. Thank you!", actiontitle: "OK")
                            {
                                self.view.removeFromSuperview()
                            }
                        }
                    }
                }
                
            case .failure(let encodingError):
                     self.view.activityStopAnimating()
                Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Somthing went wrong. Please check internet connection")
                print(encodingError)
            }
            
        }
        
        
    }
    
    
    
    func validation() -> Bool
    {
        
        if txtName.text == ""
        {
            self.toast.isShow("Please enter name")
            return false
        }
        if txtEmail.text == ""
        {
           self.toast.isShow("Please enter email ID")
            return false
        }
        if txtMobileNo.text == ""
        {
            self.toast.isShow("Please enter mobile no.")
            return false
        }
        if txtRegNo.text == ""
        {
            self.toast.isShow("Please enter your registration no.")
            return false
        }
    
        if !(txtEmail.text?.isValidEmail())!
        {
            self.toast.isShow("Please enter valid email")
            return false
        }
        
        if txtEmail.errorMessage != ""
        {
            self.toast.isShow("Please enter valid email")
            return false
        }
        
        return true
    }
    
   
}
extension SignUpFormVC : TagViewDelegate {
    func tagDismissed(_ tag: TagView) {
        print("tag dismissed: " + tag.text)
    }
    
    func tagTouched(_ tag: TagView) {
        print("tag touched: " + tag.text)
    }
}
extension SignUpFormVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtQualification
        {
            dropdownQualification.show()

            if let text = textField.text,
                let textRange = Range(range, in: text)
            {
                self.dropdownQualification.show()
                
                let updatedText = text.replacingCharacters(in: textRange,with: string)
                
                let AutoWordsArr = self.dropdownQualification.dataSource
                
                self.m_cFilterdArr = AutoWordsArr.filter( { $0.lowercased().prefix(updatedText.count) == updatedText.lowercased() })
                
                self.dropdownQualification.dataSource = self.m_cFilterdArr
                self.dropdownQualification.reloadAllComponents()
                
                dropdownQualification.selectionAction = { [unowned self] (index: Int, item: String) in
                    
                     self.QualificationtagView.tags.append(TagView(text: item))
                     self.selectQualificationString.append(item)
                     self.txtQualification.text = ""
                }
            }
        }
        
        if textField == txtMobileNo
        {
            guard let text = txtMobileNo.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 10
        }
        return true
    }
    
}
extension UIScrollView
{
    func scrollToTop()
    {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top); setContentOffset(desiredOffset, animated: true)
    }
    
}
