//
//  OpenImageInWeb.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/12/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Kingfisher

class OpenImageInWeb: UIViewController
{
    @IBOutlet weak var imgReport: UIImageView!
    var image_name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image_name != nil
        {
            let Imgurl = URL(string: image_name)
            imgReport.kf.setImage(with: Imgurl)
        }
        
        
    }
    
    @IBAction func btnBack_onClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func loadUrl(str : String){
//
//        let url = URL(string: str)
//        let requestObj = URLRequest(url: url! as URL)
//       imgWeb.loadRequest(requestObj)
//
//    }
    
}
