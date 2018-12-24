//
//  PrescriptionViewController.swift
//  Test
//
//  Created by Prem Sahni on 06/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
//import LCPaintView
import DropDown

class PrescriptionViewController: UIViewController {

    @IBOutlet var cancel : UIButton!
    @IBOutlet var brushColor : UIButton!
    @IBOutlet var brushWidth : UIButton!
    @IBOutlet var save : UIButton!
    @IBOutlet var clear : UIButton!
    @IBOutlet var Eraser : UIButton!
    @IBOutlet var undo : UIButton!

    var selected = Bool(true)
    var selectedWidth = 10
    var selectedColor = UIColor()
    let dropdownWidth = DropDown()
    let dropdownColor = DropDown()
    var Selectedindex = 0
    let color = ["#000000","#FFFB00","#0096FF","#8EFA00","#FF2600","#FF7E79","FF9300"]
    
    @IBOutlet var Paintview: LCPaintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 20)

        dropdownWidth.arrowIndicationX = 50
        dropdownColor.arrowIndicationX = 50
        
        dropdownWidth.anchorView = brushWidth
        dropdownColor.anchorView = brushColor
        
        dropdownWidth.dataSource = ["10","15","20","25","30"]
        dropdownColor.dataSource = ["Black","Yellow","Blue","Green","Red","Pink","Orange"]
        
        dropdownWidth.direction = .bottom
        dropdownColor.direction = .bottom
        
        dropdownWidth.bottomOffset = CGPoint(x: 0, y:(dropdownWidth.anchorView?.plainView.bounds.height)!)
        dropdownColor.bottomOffset = CGPoint(x: 0, y:(dropdownColor.anchorView?.plainView.bounds.height)!)
        
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        brushColor.addTarget(self, action: #selector(brushColorAction), for: .touchUpInside)
        brushWidth.addTarget(self, action: #selector(brushWidthAction), for: .touchUpInside)
        save.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        clear.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        Eraser.addTarget(self, action: #selector(EraserAction), for: .touchUpInside)
        undo.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
        
        self.selectedColor = hexStringToUIColor(hex: "#000000")
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("Updated"), object: nil)
        // Do any additional setup after loading the view.
        
    }
    
/*    @objc func change()
    {
        Paintview.lineColor = selectedColor
        Paintview.lineWidth = Float(selectedWidth)
        brushColor.titleLabel?.textColor = hexStringToUIColor(hex: color[Selectedindex])
    }
 
 */
    
    
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
        self.dismiss(animated: true, completion: nil)
    }
    @objc func brushColorAction(){
        dropdownColor.show()
        dropdownColor.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedColor = self.hexStringToUIColor(hex: self.color[index])
            self.brushColor.titleLabel?.textColor = self.hexStringToUIColor(hex: self.color[index])
            self.brushColor.setTitle(item, for: .normal)
            self.Selectedindex = index
            NotificationCenter.default.post(name: NSNotification.Name("Updated"), object: self)
            print("Selected item: \(item) at index: \(index)")
        }
    }
    @objc func brushWidthAction(){
        dropdownWidth.show()
        dropdownWidth.selectionAction = { [unowned self] (index: Int, item: String) in
            self.brushWidth.setTitle("Width : \(item)", for: .normal)
            self.selectedWidth = Int(item)!
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    @objc func saveAction(){
        if Paintview.image != nil{
            NotificationCenter.default.post(name: NSNotification.Name("addImage"), object: self, userInfo: ["image" : Paintview.image!])
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
}
extension UIView {
    
    // If Swift version is lower than 4.2, 
    // You should change the name. (ex. var renderedImage: UIImage?)
    
    var image: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}
