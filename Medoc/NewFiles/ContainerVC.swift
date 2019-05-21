

import UIKit

class ContainerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var loginvc : LoginVC!
    var signupvc : SignUpFormVC!
    var passwordvc : ForgetPasswordVC!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        UIView.animate(withDuration: 1.0) {
            
            self.loginvc.view.frame = self.containerView.bounds
            self.containerView.addSubview(self.loginvc.view)
            self.containerView.layer.cornerRadius = 20.0
            self.containerView.clipsToBounds = true
            self.containerView.designCell()
        }
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
        
        self.addChild(self.signupvc)
        
        self.containerView.addSubview(self.signupvc.view)
        self.signupvc.view.clipsToBounds = true
        
//        UIView.transition(with: self.containerView,
//                          duration: 1.0,
//                          options: [.transitionFlipFromRight],
//                          animations: {
//
//                            self.signupvc.view.frame = self.containerView.bounds
//
//                        self.addChild(self.signupvc)
//
//                        self.containerView.addSubview(self.signupvc.view)
//                                 self.signupvc.view.clipsToBounds = true
//        },
//                          completion: nil)
        
    }
    
    func showForgetpassword()
    {
        self.passwordvc.view.frame = self.containerView.bounds
        self.containerView.addSubview(self.passwordvc.view)
        self.passwordvc.view.clipsToBounds = true
//
//        UIView.transition(with: self.containerView,
//                          duration: 1.0,
//                          options: [.transitionCurlUp],
//                          animations: {
//
//                            self.passwordvc.view.frame = self.containerView.bounds
//
//
//                         self.containerView.addSubview(self.passwordvc.view)
//                              self.passwordvc.view.clipsToBounds = true
//
//        },
//                          completion: nil)
//
        
      
    }

}
