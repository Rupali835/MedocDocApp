

import UIKit

class ContainerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var loginvc : LoginVC!
    var signupvc : SignUpFormVC!
    var passwordvc : ForgetPasswordVC!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginvc.view.frame = self.containerView.bounds
        self.containerView.addSubview(self.loginvc.view)
        
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.loginvc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.loginvc.initilize(cContainerVC: self)
        self.didMove(toParent: self)
        
        self.signupvc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpFormVC") as? SignUpFormVC
        self.signupvc.initilize(cContainervc: self)
        
        self.passwordvc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
        self.passwordvc.initilize(cContainervc: self)
        
        
    }
    
    func showsign()
    {
        self.signupvc.view.frame = self.containerView.bounds
        self.containerView.addSubview(self.signupvc.view)
        
    }
    
    func showForgetpassword()
    {
        self.passwordvc.view.frame = self.containerView.bounds
        self.containerView.addSubview(self.passwordvc.view)
    }

}
