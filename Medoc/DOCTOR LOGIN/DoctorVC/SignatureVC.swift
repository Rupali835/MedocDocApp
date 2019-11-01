//
//  SignatureVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/3/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

protocol signProtocol {
    func signImg(imgsign : UIImage, imgName : String)
}

class SignatureVC: UIViewController
{

    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var PaintView: LCPaintView!
    
    var selected = Bool(true)
    var selectedWidth = 1.5
    var selectedColor = UIColor()
    var Selectedindex = 0
    var m_cSignDelegate : signProtocol!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnClear.addTarget(self, action: #selector(clearForm), for: .touchUpInside)
        btnDone.addTarget(self, action: #selector(DoneForm), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(cancelForm), for: .touchUpInside)
        
        self.selectedColor = hexStringToUIColor(hex: "#000000")
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("Updated"), object: nil)

    }
    
   
    @objc func change(){
        PaintView.lineColor = selectedColor
        PaintView.lineWidth = Float(selectedWidth)
    
    }
    override func viewWillAppear(_ animated: Bool)
    {
        PaintView.clear()
        PaintView.lineColor = selectedColor
        PaintView.lineWidth = Float(selectedWidth)
    
    }
    override func viewDidLayoutSubviews() {
        PaintView.lineColor = selectedColor
        PaintView.lineWidth = Float(selectedWidth)
   //     brushColor.titleLabel?.textColor = hexStringToUIColor(hex: color[Selectedindex])
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    @objc func clearForm()
    {
        self.PaintView.clear()
    }
    
    @objc func DoneForm()
    {
        if PaintView.paintimage != nil{
            NotificationCenter.default.post(name: NSNotification.Name("addImage"), object: self, userInfo: ["image" : PaintView.paintimage!])
            
            let drawImg = PaintView.paintimage
            
            let imgnm = PaintView.paintimage?.accessibilityIdentifier = "sign_imageNm"

            print(imgnm)
            
            m_cSignDelegate.signImg(imgsign: drawImg!, imgName: "")
            self.view.removeFromSuperview()
            
        }
    }
    
    @objc func cancelForm()
    {
        self.view.removeFromSuperview()
    }
   

}
