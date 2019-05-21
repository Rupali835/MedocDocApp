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
    
    @IBAction func btnPrintPdf_onClick(_ sender: Any)
    {
        let printController = UIPrintInteractionController.shared
        
        let pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = UIPrintInfo.OutputType.general
        pInfo.jobName = pdfWebview.request?.url!.absoluteString ?? ""
        pInfo.orientation = UIPrintInfo.Orientation.portrait
        
//        let formatter = UIMarkupTextPrintFormatter(markupText: self.UrlStr)
//        formatter.perPageContentInsets = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
//        
//        printController.printFormatter = formatter
     
        printController.printInfo = pInfo
        printController.showsNumberOfCopies = true
        printController.printFormatter = pdfWebview.viewPrintFormatter()
        printController.present(animated: true, completionHandler: nil)    
        
    }
    
    
}
