
import UIKit
import Alamofire
import SVProgressHUD

class LoginVC: UIViewController
{
   
    @IBOutlet weak var btnNewUser: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtUserNm: HoshiTextField!
    @IBOutlet weak var txtPassword: HoshiTextField!
    
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var animateView: GradientView!
    
    var m_cContainerVC = ContainerVC()
    var SignupVc : SignUpFormVC!
    var toast = JYToast()
    var b_tutorial = Bool(false)
    var iconClick : Bool!

    func initilize(cContainerVC: ContainerVC)
    {
        self.m_cContainerVC = cContainerVC
      
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnLogin.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
        self.navigationController?.navigationBar.isHidden = true
         btnEye.setImage(UIImage(named: "hide"), for: .normal)
        iconClick = true

    }
    
    @IBAction func btnShowPassword_onclick(_ sender: Any)
    {
        
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
             btnEye.setImage(UIImage(named: "eye"), for: .normal)
            iconClick = false
        } else {
            txtPassword.isSecureTextEntry = true
             btnEye.setImage(UIImage(named: "hide"), for: .normal)
            iconClick = true
        }
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
        self.view.endEditing(true)
        if validation()
        {
            
            OperationQueue.main.addOperation {
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.setBackgroundColor(UIColor.gray)
                SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
                SVProgressHUD.show()
            }

            if Reachability.isConnectedToNetwork(){
                 Login()
            }else{
                
                OperationQueue.main.addOperation {
                    
                    SVProgressHUD.dismiss()
                }
                
                Alert.shared.basicalert(vc: self, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
                
            }
          
        }
    }
    
    func Login()
    {

        let LoginApi = Constant.BaseUrl+Constant.LoginDoctor
        
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
//
//                    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//
//                    if launchedBefore          //true
//                    {
          //              print("Not first launch.")
                        
                        let yourVc : SWRevealViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let navigationController = appDelegate.window!.rootViewController as! UINavigationController
                        navigationController.setViewControllers([yourVc], animated: true)
//                    }
//                    else                       //false
//                    {
//                        print("First launch, setting UserDefault.")
//                        UserDefaults.standard.set(true, forKey: "launchedBefore")
//
//                        let yourVc : TutorialVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        let navigationController = appDelegate.window!.rootViewController as! UINavigationController
//                        navigationController.setViewControllers([yourVc], animated: true)
//
//                    }
                    OperationQueue.main.addOperation {
                        
                        SVProgressHUD.dismiss()
                    }
                    
                    
                }else{
                    
                    
                    OperationQueue.main.addOperation {
                        
                        SVProgressHUD.dismiss()
                    }

                    let Data = json["reason"] as! String
                    if Data == "User Is Already LoggedIn In Another Device."
                    {
                        self.toast.isShow("User Is Already LoggedIn In Another Device. Please check it.")
                    }
                    
                    if Data == "User Not Found.Please Check Login Credentials."
                    {
                       self.toast.isShow("Check Username or Password..")
                    }
                    
                }
                
                break
                
            case .failure(_):
                OperationQueue.main.addOperation {
                    
                    SVProgressHUD.dismiss()
                }
                 Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Somthing went wrong. Please check internet connection")
              
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
    
    func isValidNumber() -> Bool
    {
       // let phoneNumberRegex = "^[7-9][0-9]{8,9}$"
        
        let phoneNumberRegex = "^(?:|0|[1-9]\\d*)(?:|0|[/]\\d*)(?:\\.\\d*)?$"
         let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        
        return phoneTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool
    {
        // let phoneNumberRegex = "^[7-9][0-9]{8,9}$"
        
        let phoneNumberRegex = "^(?:|0|[a-z]\\d*)(?:|0|[A-Z]\\d*)(?:\\.\\d*)?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        
        return phoneTest.evaluate(with: self)
    }
    
    
}
