

import Foundation
import UIKit
import ZAlertView

extension UIView{
    func designCell()
    {
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.red.cgColor
        self.backgroundColor = UIColor.white
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
