//
//  PrescriptionViewController.swift
//  Test
//
//  Created by Prem Sahni on 06/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//


import UIKit
import DropDown
import ZAlertView


protocol PaintDocsDelegate {
    
    func DrawingDocs(docImg : UIImage, doctag : String, doctimeStamp : String)  // for drawing
    
    func PaintDocs(docs : UIImage, docnm : String, docTimeStamp : String) // for prescription
}

class PrescriptionViewController: UIViewController {

    @IBOutlet var cancel : UIButton!
    @IBOutlet var brushColor : UIButton!
    @IBOutlet var brushWidth : UIButton!
    @IBOutlet var save : UIButton!
    @IBOutlet var clear : UIButton!
    @IBOutlet var Eraser : UIButton!
    @IBOutlet var undo : UIButton!

    var selected = Bool(true)
    var selectedWidth = 3
    var selectedColor = UIColor()
  
    var Selectedindex = 0
    let color = ["#000000","#FFFB00","#0096FF","#8EFA00","#FF2600","#FF7E79","FF9300"]
    
    var paintImgArr = [UIImage]()
    
    var m_cPaintDocsdelegate : PaintDocsDelegate!
    var alertWithText = ZAlertView()
    var m_bView = Bool(false)
    var m_cdraw_arr = [DrawingArr]()
    
    var m_cPressData: CPressData!
    var m_cDrawData: CDrawData!
    
    @IBOutlet var Paintview: LCPaintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 20)

        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
   
        save.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        clear.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        Eraser.addTarget(self, action: #selector(EraserAction), for: .touchUpInside)
        undo.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
        
        self.selectedColor = hexStringToUIColor(hex: "#000000")
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("Updated"), object: nil)

    }
    

    @objc func change(){
        Paintview.lineColor = selectedColor
        Paintview.lineWidth = Float(selectedWidth)
        brushColor.titleLabel?.textColor = hexStringToUIColor(hex: color[Selectedindex])
    }
    override func viewWillAppear(_ animated: Bool) {
        Paintview.lineColor = selectedColor
        Paintview.lineWidth = Float(selectedWidth)
        brushColor.titleLabel?.textColor = hexStringToUIColor(hex: color[Selectedindex])
    }
    override func viewDidLayoutSubviews() {
        Paintview.lineColor = selectedColor
        Paintview.lineWidth = Float(selectedWidth)
        brushColor.titleLabel?.textColor = hexStringToUIColor(hex: color[Selectedindex])
    }
    @objc func cancelAction(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

    
    @objc func saveAction(){
        if Paintview.image != nil{
            
          if self.m_bView == false
            {
                let drawImg = self.Paintview.image
                self.paintImgArr.append(drawImg!)
                
                
                let timestamp = Date().toMillis()
                drawImg?.accessibilityIdentifier = String(describing: timestamp)
                
                let lcPresObj = PresArr(cPressImg: drawImg!, cTimestamp: String(describing: timestamp!))
              self.m_cPressData.m_cPressDataArr.append(lcPresObj)
                
                let prescvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddPrescriptionDrawingVC") as! AddPrescriptionDrawingVC
                
              prescvc.m_cPressData = self.m_cPressData
              self.navigationController?.pushViewController(prescvc, animated: true)
                
            }else
            {
                 openPopupName()
            }
            

        }
    }

    
    func openPopupName()   // For drawing
    {
        
        UIView.animate(withDuration: 1.0) {
            
            ZAlertView.showAnimation = .fadeIn
            
            self.alertWithText = ZAlertView(title: "Medoc", message: "Enter the name which you want to save the drawing", isOkButtonLeft: false, okButtonText: "Save", cancelButtonText: "Cancel", okButtonHandler: { (send) in
                
                let txt1 = self.alertWithText.getTextFieldWithIdentifier("Remark")!
                
                let docNm = txt1.text!
                

                NotificationCenter.default.post(name: NSNotification.Name("addImage"), object: self, userInfo: ["image" : self.Paintview.image!])
                
                let drawImg = self.Paintview.image
                self.paintImgArr.append(drawImg!)
                
                let timestamp = Date().toMillis()
                drawImg?.accessibilityIdentifier = String(describing: timestamp)
               
                let lcDrawObj = DrawingArr(cDrawImg: self.Paintview.image!, cDrawTag: docNm, cDrawTimestamp: String(describing: timestamp!))
                
                self.m_cDrawData.m_cDrawDataArr.append(lcDrawObj)
                
         let lcDrawDataVC = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddDrawingVC") as! AddDrawingVC
           
                lcDrawDataVC.m_cDrawData = self.m_cDrawData
          
            self.navigationController?.pushViewController(lcDrawDataVC, animated: true)
                
                send.dismissWithDuration(0.5)
                ZAlertView.hideAnimation = .fadeOut
                
            }) { (cancel) in
                cancel.dismissWithDuration(0.5)
            }
            self.alertWithText.addTextField("Remark", placeHolder: "Enter the name of drawing")
            self.alertWithText.showWithDuration(1.0)
        }
    }
    
    
    @objc func clearAction(){
        self.Paintview.clear()
    }
    
    @objc func EraserAction(){
        if selected == true {
            selectedColor = UIColor.white
            Paintview.lineColor = selectedColor
            Paintview.lineWidth = Float(selectedWidth + 40)
            Eraser.setTitle("Done", for: .normal)
            selected = false
        } 
        else if selected == false {
            selectedColor = hexStringToUIColor(hex: self.color[Selectedindex])
            Paintview.lineColor = selectedColor
            Paintview.lineWidth = Float(selectedWidth)
            Eraser.setTitle("Eraser", for: .normal)
            selected = true
        }
    }
    @objc func undoAction(){
        self.Paintview.undo()
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
    
    
    @IBAction func btnBrush1_onClick(_ sender: Any)
    {
        self.selectedColor = UIColor.black
        self.selectedWidth = 10
        Paintview.lineWidth = Float(selectedWidth)
        Paintview.lineColor = self.selectedColor
    }
    
    @IBAction func btnBrush2_onclick(_ sender: Any)
    {
        self.selectedColor = UIColor.black
        self.selectedWidth = 3
        Paintview.lineWidth = Float(selectedWidth)
        Paintview.lineColor = self.selectedColor
    }
    
    @IBAction func btnBrush3_onclick(_ sender: Any)
    {
        self.selectedColor = UIColor.black
        self.selectedWidth = 8
        Paintview.lineWidth = Float(selectedWidth)
        Paintview.lineColor = self.selectedColor
    }
    
    
    @IBAction func btnEraser_onclick(_ sender: Any)
    {
        selectedColor = UIColor.white
        Paintview.lineColor = selectedColor
        Paintview.lineWidth = Float(selectedWidth + 40)
    }
    
    
    @IBAction func btnRedColor_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#FF2600")
     
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
    
    }
    
    @IBAction func btnBlackclr_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#000000")
     
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
    }
    
    @IBAction func btnPurplt_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#673AB7")
        
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
      }
    
    @IBAction func btnBlue_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#0433FF")
        
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
    }
    
    @IBAction func btnGreen_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#4F8F00")
        
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
    }
    
    @IBAction func btnDarkRed_onclick(_ sender: Any)
    {
        self.selectedColor = self.hexStringToUIColor(hex: "#941100")
        
        NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
    }
    
}
extension UIView {
    
    var image: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
    
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext)
        
        }
    }
}

