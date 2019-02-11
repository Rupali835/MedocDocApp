//
//  AboutUsVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import SVProgressHUD

class AboutUsVC: UIViewController {

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var aboutWebview: UIWebView!
    
    override func viewDidLoad() {
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
        
        let url = URL(string: "http://ksoftpl.com/about-us")
        let requestObj = URLRequest(url: url! as URL)
        aboutWebview.loadRequest(requestObj)
        
        OperationQueue.main.addOperation {
           
            SVProgressHUD.dismiss()
        }
        
    }

    func sideMenus()
    {
        
        if revealViewController() != nil {
            
            self.btnBack.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
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
