
import UIKit
import Alamofire
import ZAlertView
import CloudTagView
import DropDown
import SkyFloatingLabelTextField

class SignUpFormVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

   
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
    
    var imagePicker = UIImagePickerController()
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
   // var m_csignVc = SignUpFormVC()
    
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
       if validation()
       {
          sendData()
       }
        
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        btnProfileImg.setImage(tempImage, for: .normal)
        
        let timestamp = Date().toMillis()
        tempImage.accessibilityIdentifier = String(describing: timestamp)
        self.fileName = String(describing: timestamp!)
        self.selectedImage = tempImage
        
        self.m_cContainerVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.m_cContainerVC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCamera_onClick(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: "Select Photo", message: "Select atleast one photo", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "Camera", style: .default) { (action) in

           alertController.dismiss(animated: true, completion: nil)

            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.imagePicker.sourceType = .camera
                self.m_cContainerVC.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
                alertWarning.show()
            }


        }
        let action2 = UIAlertAction(title: "Gallery", style: .default) { (action) in

            self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            self.imagePicker.delegate = self
            self.m_cContainerVC.present(self.imagePicker, animated: true, completion: nil)


        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Destructive is pressed....")

        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        

        self.m_cContainerVC.present(alertController, animated: true, completion: nil)

 
        
       /*  Rupali
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            
            
            let timestamp = Date().toMillis()
            image.accessibilityIdentifier = String(describing: timestamp)
            
            self.fileName = String(describing: timestamp!)
            self.btnProfileImg.setImage(image, for: .normal)
            
            self.selectedImage = image
            
        }*/
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
       
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.selectedImage != nil
                {
                    
                   
                    let data = self.selectedImage.jpegData(compressionQuality: 0.0)
                    
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
                                if Msg == "success"
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
    
//    func TakePhoto()
//    {
//        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
//
//
//            for lcAttachment in CDBAttachmentArr
//            {
//                self.fileName = lcAttachment.fileName
//                print(self.fileName)
//
//                lcAttachment.loadOriginalImage(completion: {image in
//
//
//                    let timestamp = Date().toMillis()
//                    image?.accessibilityIdentifier = String(describing: timestamp)
//
//                    self.fileName = String(describing: timestamp!)
//                    self.btnProfileImg.setImage(image, for: .normal)
//
//                    self.selectedImage = image
//                })
//
//            }
//
//        }, cancel: nil)
//
//        attachmentPickerController.mediaType = .image
//        attachmentPickerController.mediaType = .video
//        attachmentPickerController.capturedVideoQulity = UIImagePickerController.QualityType.typeHigh
//        attachmentPickerController.allowsMultipleSelection = false
//        attachmentPickerController.allowsSelectionFromOtherApps = false
//        attachmentPickerController.present(on: self)
//    }
    
    
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
