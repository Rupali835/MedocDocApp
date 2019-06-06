//
//  AboutUsVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class AboutUsVC: UIViewController, WKUIDelegate, WKNavigationDelegate
{

    
    @IBOutlet weak var loader: DotsLoader!
    @IBOutlet weak var btnBack: UIButton!
  //  @IBOutlet weak var aboutWebview: UIWebView!
    
    @IBOutlet weak var aboutWebview: WKWebView!
    
  //  var webView: WKWebView!
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView = WKWebView(frame: CGRect.zero)
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
        
        self.loader.startAnimating()
        loadUrl()
    }
    
    func loadUrl(){
        
        let url = URL(string: "http://ksoftpl.com/about-us")
        let requestObj = URLRequest(url: url! as URL)
        aboutWebview.load(requestObj)
    }

    func showActivityIndicator(show: Bool) {
        if show {
            self.loader.startAnimating()
            self.loader.isHidden = false      //true
        } else {
            self.loader.stopAnimating()
            self.loader.isHidden = true // false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
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
