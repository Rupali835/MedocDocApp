//
//  OpenImageInWeb.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/12/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class OpenImageInWeb: UIViewController
{

    @IBOutlet weak var imgWeb: UIWebView!
    
    var image_name = String()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image_name != nil
        {
            loadUrl(str : image_name)
        }
        
        
    }
    
    @IBAction func btnBack_onClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadUrl(str : String){
        
        let url = URL(string: str)
        let requestObj = URLRequest(url: url! as URL)
       imgWeb.loadRequest(requestObj)
        
    }
    
}
