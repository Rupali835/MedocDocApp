//
//  AboutUsVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {

    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var aboutWebview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUrl()
    }
    
    func loadUrl(){
        
        let url = URL(string: "http://ksoftpl.com/about-us")
        let requestObj = URLRequest(url: url! as URL)
        aboutWebview.loadRequest(requestObj)
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
