//
//  DoctorProfileVc.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/11/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class DoctorProfileVc: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }

    func sideMenus()
    {
        
        if revealViewController() != nil {
            
            self.btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
        }
    }
    
    @IBAction func btnback_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)

    }
    
}
