
import UIKit
import Alamofire

class LoginVC: UIViewController
{
   
    @IBOutlet weak var btnNewUser: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserNm: HoshiTextField!
    @IBOutlet weak var txtPassword: HoshiTextField!
    
    var m_cContainerVC = ContainerVC()
    var SignupVc : SignUpFormVC!
    var toast = JYToast()
    
    func initilize(cContainerVC: ContainerVC)
    {
        self.m_cContainerVC = cContainerVC
      // self.SignupVc.initilize(cContainervc: self.m_cContainerVC)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnLogin.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
      
    }
  

    @IBAction func btnForgetPassword_onClick(_ sender: Any)
    {
       self.m_cContainerVC.showForgetpassword()
    }
    
    @IBAction func btnNewUser_onClick(_ sender: Any)
    {
        self.m_cContainerVC.showsign()
    }
    
    @IBAction func btnLogin_onClick(_ sender: Any)
    {

//        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PatientListVC") as! PatientListVC
//      //  present(vc, animated: true, completion: nil)
//
//        let appdel = UIApplication.shared.delegate as! AppDelegate
//
//        let navigationController = appdel.window?.rootViewController as! UINavigationController
//        navigationController.setViewControllers([vc], animated: true)
//        

       if validation()
        {
         Login()

        }
    }
    
    func Login()
    {
        let LoginApi = "http://otgmart.com/medoc/medoc_test/public/api/login"
        
        let Param = ["username" : txtUserNm.text!,
                     "password" : txtPassword.text!
                    ]
        
        Alamofire.request(LoginApi, method: .post, parameters: Param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
               
                let json = resp.result.value as! NSDictionary
                
                let Msg = json["msg"] as! String
                
                if Msg == "success"
                {
                    let userData = json["data"] as! NSDictionary
                    UserDefaults.standard.set(userData, forKey: "userData")
                    
                    let cliniclist = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: PatientListVC.storyboardID)
                    
                    self.present(cliniclist, animated: true, completion: nil)
                }
                
                break
                
            case .failure(_):
                
                break
            }
        }
    }
    
    func validation() -> Bool
    {
        if txtUserNm.text == "" && txtPassword.text == ""
        {
            toast.isShow("Both fields are mandetory")
            return false
        }
        
        if txtUserNm.text == "" || txtPassword.text == ""
        {
            toast.isShow("Both fields are mandetory")
            return false
        }
    
        
        return true
    }
    
}
extension String {
    func isValidPassword() -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,10}$"
        
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        
        return passwordValidation.evaluate(with: self)
    }
}
