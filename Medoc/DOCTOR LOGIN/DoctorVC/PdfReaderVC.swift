//
//  PdfReaderVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class PdfReaderVC: UIViewController {

    var UrlStr = String()
    
    @IBOutlet weak var pdfWebview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print(self.UrlStr)
        let fileURL = URL(fileURLWithPath: self.UrlStr)
        let fileRequest = URLRequest(url: fileURL)
        self.pdfWebview.loadRequest(fileRequest)
    }

   
    @IBAction func btnback_onclcik(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
