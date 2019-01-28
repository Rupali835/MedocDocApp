//
//  newsFeedWebViewVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/28/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class newsFeedWebViewVC: UIViewController
{

    @IBOutlet weak var newsWebview: UIWebView!
    
    var urlStr = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadUrl()
    }
    
    func loadUrl(){
        
        let url = URL(string: urlStr)
        let requestObj = URLRequest(url: url! as URL)
        newsWebview.loadRequest(requestObj)
    }
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
