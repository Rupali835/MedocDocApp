

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Main, Doctor, IphoneMain, IphoneDoctor
    
    var instance : UIStoryboard {
        print(self.rawValue)
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension UIViewController
{
  // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    
}
