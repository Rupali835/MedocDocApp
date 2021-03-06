//
//  MedocInfowebVc.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/31/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class MedocInfowebVc: UIViewController {

    @IBOutlet weak var backview: UIButton!
    
    @IBOutlet weak var medocWebview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadUrl()
    }
    
    func loadUrl(){
        
        let url = URL(string: "http://ksoftpl.com/")
        let requestObj = URLRequest(url: url! as URL)
        medocWebview.loadRequest(requestObj)
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            self.backview.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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

}
