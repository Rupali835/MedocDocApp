

import Foundation
import UIKit
import ZAlertView

extension UIView{
    func designCell()
    {
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.white
        
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowOffset = CGSize(width: -1, height: 1)
//        self.layer.shadowRadius = 5.0
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.backgroundColor = UIColor.white
        
    }
}
extension UIView {
    func CornerRadius(objects: [UIView],cornerRadius: CGFloat) {
        for obj in objects{
            obj.layer.cornerRadius = cornerRadius
            obj.clipsToBounds = true
        }
    }
}

extension ZAlertView
{
    public convenience init?(title: String,msg: String,dismisstitle: String,actiontitle: String,actionCompletion: @escaping()->())
    {
        let alert = ZAlertView(title: title, message: msg, alertType: ZAlertView.AlertType.multipleChoice)
        alert.addButton(actiontitle, font: UIFont.boldSystemFont(ofSize: 18), color: UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0), titleColor: UIColor.white) { (action) in
            actionCompletion()
            alert.dismissAlertView()
        }
        alert.addButton(dismisstitle, font: UIFont.boldSystemFont(ofSize: 18), color: UIColor.groupTableViewBackground, titleColor: UIColor.black) { (dismiss) in
            alert.dismissAlertView()
        }
        alert.show()
        self.init()
    }
    
    public convenience init?(title: String,msg: String,actiontitle: String,actionCompletion: @escaping()->())
    {
        let alert = ZAlertView(title: title, message: msg, alertType: ZAlertView.AlertType.multipleChoice)
        alert.addButton(actiontitle, font: UIFont.boldSystemFont(ofSize: 20), color: UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0), titleColor: UIColor.white) { (action) in
            actionCompletion()
            alert.dismissAlertView()
        }
        
        alert.show()
        self.init()
    }

}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//        let backColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
//
//        let dialog = ZAlertView(title: nil, message: nil, alertType: ZAlertView.AlertType.multipleChoice)
//
//        dialog.addButton("Scan Document", font: UIFont.systemFont(ofSize: 27), color: backColor, titleColor: UIColor.black) { (altview) in
//
//            let scannerVC = ImageScannerController()
//            scannerVC.imageScannerDelegate = self
//            self.present(scannerVC, animated: true, completion: nil)
//            altview.dismissAlertView()
//        }
//
//        dialog.addButton("Take Photo", font: UIFont.systemFont(ofSize: 27), color: backColor, titleColor: UIColor.black) { (altview) in
//            self.TakePhoto()
//            altview.dismissAlertView()
//        }
//
//        dialog.addButton("Photo Library", font: UIFont.systemFont(ofSize: 27), color: backColor, titleColor: UIColor.black) { (altview) in
//            self.TakePhoto()
//            altview.dismissAlertView()
//        }
//
//        dialog.addButton("Add Sketch", font: UIFont.systemFont(ofSize: 27), color: backColor, titleColor: UIColor.black) { (altview) in
//            altview.dismissAlertView()
//            var appstory = AppStoryboard.Doctor
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                appstory = AppStoryboard.Doctor
//            } else {
//                appstory = AppStoryboard.IphoneDoctor
//            }
//            let vc = appstory.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
//            vc.m_cPaintDocsdelegate = self
//            self.present(vc, animated: true, completion: nil)
//        }
//
//        dialog.addButton("Cancel", font: UIFont.systemFont(ofSize: 27), color: UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0), titleColor: UIColor.white) { (altview) in
//            altview.dismissAlertView()
//        }
//
//        dialog.show()
