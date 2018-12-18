
import UIKit
import Alamofire
import ZAlertView

class SignUpFormVC: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtQualification: HoshiTextField!
    @IBOutlet weak var txtRegNo: HoshiTextField!
    @IBOutlet weak var txtMobileNo: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var btnProfileImg: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegister.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
    
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
   
    // MARK : FUNCTIONS
    
    func sendData()
    {
        
        if txtQualification.text == ""
        {
            txtQualification.text = "NF"
        }
        
        //let Mobile_No = Int(txtMobileNo.text!)
        
        let SignupApi = "http://otgmart.com/medoc/medoc_test/public/api/doc_signup_api"
        
        let param = ["name" : txtName.text!,
                     "email" : txtEmail.text!,
                     "contact_no" : txtMobileNo.text! ,
                     "qualification" : txtQualification.text!,
                     "registration_no" : txtRegNo.text!,
                     "profile_picture" : ""
                     
            ] as! Parameters
        
        print(param)
        
       Alamofire.request(SignupApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)

            switch resp.result
            {
            case .success(_):

                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "Added Successfully"
                {
                    ZAlertView.init(title: "Medoc", msg: "Your data will be sent to server. You will get email with login details in Medoc App. Thank you!", actiontitle: "OK")
                    {
                        self.view.removeFromSuperview()
                    }
                }else if Msg == "Already exit"
                {
                   
                    ZAlertView.init(title: "Medoc", msg: "Mobile number or Email has already available on server. Please use another.", actiontitle: "OK")
                    {
                        print("")
                    }
                }else if Msg == "User not found"
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
        
        if ((txtMobileNo.text?.count)! < 10) || ((txtMobileNo.text?.count)! > 10)
        {
            self.toast.isShow("Please enter valid mobile number")
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
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
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
