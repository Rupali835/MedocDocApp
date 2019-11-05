//
//  ContactUsVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactUsVC: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var contactWebview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        
        loadUrl()
    }
  
   
    
    func loadUrl(){
        
        let url = URL(string: "http://ksoftpl.com/contact-us")
        let requestObj = URLRequest(url: url! as URL)
       contactWebview.loadRequest(requestObj)
        OperationQueue.main.addOperation {
            
            SVProgressHUD.dismiss()
        }
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            self.btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            if UIDevice.current.userInterfaceIdiom == .pad {
                revealViewController().rearViewRevealWidth = 400
                revealViewController().rightViewRevealWidth = 180
            } else {
                revealViewController().rearViewRevealWidth = 260
                revealViewController().rightViewRevealWidth = 180
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }

    
    @IBAction func btnback_onclick(_ sender: Any)
    {
      dismiss(animated: true, completion: nil)
    }
}
