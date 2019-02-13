
import UIKit
import Alamofire
import ZAlertView
import CloudTagView
import DropDown
import SkyFloatingLabelTextField

class SignUpFormVC: UIViewController
{

    @IBOutlet weak var signScroll: UIScrollView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtQualification: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRegNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var imglink: UIImageView!
    @IBOutlet weak var imgcap: UIImageView!
    
    @IBOutlet weak var QualificationtagView: CloudTagView!
    
    var m_cContainerVC: ContainerVC!
    var toast = JYToast()
    var selectedImage: UIImage!
    var DocumentselectedImage: UIImage!
    var filePath: String!
    var fileURL: URL!
    var fileName: String!
    var DocumentImageFileName: String!
    var DocumentFileURL: URL!
    var DocumentFileName: String?
    var dropdownQualification = DropDown()
    var selectQualificationString = [String]()
    var m_cFilterdArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownQualification.anchorView = txtQualification
        txtQualification.delegate = self
        btnRegister.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
        
        imgcap.image = imgcap.image!.withRenderingMode(.alwaysTemplate)
        imgcap.tintColor = UIColor.white
        
        imglink.image = imglink.image!.withRenderingMode(.alwaysTemplate)
        imglink.tintColor = UIColor.white
        QualificationtagView.delegate = self
        AddJsonData()
        textValidAction()
        
        
       }

    override func viewWillAppear(_ animated: Bool) {
        signScroll.scrollToTop()
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
                    
                else {
                    
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
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
    
    func AddJsonData()
    {
        if let path = Bundle.main.path(forResource: "Type of Doctor", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let PatientProblem = jsonResult["data"] as? [AnyObject]
                {
                    print(PatientProblem)
                    
                    for lcdict in PatientProblem
                    {
                        let Name = lcdict["name"] as? String
                        
                        dropdownQualification.dataSource.append(Name!)
                        
                    }
                    
                }
            } catch {
                // handle error
                self.toast.isShow(error as! String)
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
        
       if validation()
       {
          sendData()
       }
        
    }
    
    
    @IBAction func btnCamera_onClick(_ sender: Any)
    {
        TakePhoto()
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
        
        
        let SignupApi = "http://otgmart.com/medoc/medoc_test/public/api/doc_signup_api"
        
        let param = ["name" : txtName.text!,
                     "email" : txtEmail.text!,
                     "contact_no" : txtMobileNo.text! ,
                     "qualification" : QualVal,
                     "registration_no" : txtRegNo.text!,
                     "profile_picture" : ProfilePic
                     
            ] as Parameters
        
        print(param)
       
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.selectedImage != nil
                {
                    
                   
                    let data = self.selectedImage.jpegData(compressionQuality: 0.0)
                    
              //      let data = self.selectedImage.pngData()
                    
                    multipartFormData.append(data!, withName: "profile_picture", fileName: self.fileName, mimeType: "image/jpeg")
                    
                }
                
                for (key, val) in param {
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                }
        },
            to: SignupApi,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in

                        
                            switch response.result
                            {
                            case .success(_):
                                
                                let json = response.result.value as! NSDictionary
                                let Msg = json["msg"] as! String
                                if Msg == "Added Successfully"
                                {
                                    ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details in Medoc App. Thank you!", actiontitle: "OK")
                                    {
                                        self.view.removeFromSuperview()
                                    }
                                }else if Msg == "Already exist"
                                {
                                    
                                    ZAlertView.init(title: "Medoc", msg: "Mobile number or Email has already available on server. Please use another.", actiontitle: "OK")
                                    {
                                        print("")
                                    }
                                }
                                else if Msg == "User not found"
                                {
                                    ZAlertView.init(title: "Medoc", msg: "Your data is not found, Please sign up.", actiontitle: "OK")
                                    {
                                        print("")
                                    }
                                }
                                break
                                
                            case .failure(_):
                                break
                            }
                            
                        }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
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
    
    func TakePhoto()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            
            for lcAttachment in CDBAttachmentArr
            {
                self.fileName = lcAttachment.fileName
                print(self.fileName)
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
                    
                    let timestamp = Date().toMillis()
                    image?.accessibilityIdentifier = String(describing: timestamp)
                    
                    self.fileName = String(describing: timestamp!)
                    self.btnProfileImg.setImage(image, for: .normal)
                    
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
//            dropdownQualification.selectionAction = { [unowned self] (index: Int, item: String) in
//
//                self.QualificationtagView.tags.append(TagView(text: item))
//                self.selectQualificationString.append(item)
//                print(self.selectQualificationString.count)
//            }
            
            
            
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
