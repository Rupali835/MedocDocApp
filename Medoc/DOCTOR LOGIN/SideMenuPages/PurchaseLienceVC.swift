//
//  PurchaseLienceVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/3/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Razorpay

class PurchaseLienceVC: UIViewController, RazorpayPaymentCompletionProtocol
{
    
    @IBOutlet weak var btnPay : UIButton!
    
    @IBOutlet weak var btnback: UIButton!
    var razorpay: Razorpay!
    var razorpayTestKey = "rzp_test_QxojAmZBRoofMD"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPay.addTarget(self, action: #selector(Payment), for: .touchUpInside)
        
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)
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
    

    
    @objc func Payment()
    {
        showPaymentForm()
    }

    internal func showPaymentForm()
    {
        let options: [String:Any] = [
            "amount" : "100", //mandatory in paise
            "description": "purchase description",
            "image": "https://url-to-image.png",
            "name": "business or product name",
            "prefill": [
            "contact": "9797979797",
            "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
      //  razorpay.open(options)
        razorpay.open(options, displayController: self)
    }

    
    // MARK : PAYMENT DELEGATE METHODS
    
    public func onPaymentError(_ code: Int32, description str: String){
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func onPaymentSuccess(_ payment_id: String){
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
   
    @IBAction func btnBack_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
