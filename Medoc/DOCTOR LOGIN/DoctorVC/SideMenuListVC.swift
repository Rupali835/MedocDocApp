//
//  TestVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/19/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import ZAlertView

class SideList : NSObject
{
    var menuNm : String
    var menuImg : UIImage
    
     init(cMenuNm : String, cMenuImg : UIImage) {
        self.menuNm = cMenuNm
        self.menuImg = cMenuImg
    }
}


class SideMenuListVC: UIViewController
{

    @IBOutlet weak var lblDocNm: UILabel!
    @IBOutlet weak var tblSideMenu: UITableView!
    
    var m_cSideList = [SideList]()
    var ProfileArr = [AnyObject]()
    var toast = JYToast()
    var LoginId = Int()


    var SideListArr = ["Today's Patient", "Appointments", "News Feed", "Videos", "Profile", "About Us", "Contact Us", "Logout"]
    
    var imgArr = ["signuser", "calendar", "NewsFeed", "Videos", "user (1)",  "AboutUs","ContactUs", "icon"]
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSideMenu.delegate = self
        tblSideMenu.dataSource = self
        tblSideMenu.separatorStyle = .none
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
       let Nm = dict["name"] as! String
        self.lblDocNm.text = "Dr. \(Nm)"
        self.LoginId = dict["id"] as! Int
    }
    
    
    @IBAction func btnMedocInfo_onclick(_ sender: Any)
    {
        let webvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "MedocInfowebVc") as! MedocInfowebVc
       
          revealViewController().pushFrontViewController(webvc, animated: true)
    }
    
    
    @IBAction func btnKsplLink_onClick(_ sender: Any)
    {
        guard let url = URL(string: "http://ksoftpl.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    func Logout()
    {
        let result = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        print(result)
        
//        let Token = result["token_type"] as! String
//        let AccessToken = result["access_token"] as! String
//        let Key = Token + " " + AccessToken
    //    print(Key)
        
      //  let logoutUrl = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/logout"
        
        let logoutUrl = Constant.BaseUrl+Constant.LogoutDoctor
         
        let param = ["user_id" : self.LoginId]
        print(param)
        
        Alamofire.request(logoutUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                if let Msg = json["msg"] as? String
                {
                    if Msg == "success"
                    {
                        UserDefaults.standard.removeObject(forKey: "userData")
                        
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let navigationController = appDelegate.window?.rootViewController as! UINavigationController
                        navigationController.setViewControllers([loginVC], animated: true)
                    }
                    
                }
                
                if let MSG = json["message"] as? String
                {
                    self.toast.isShow("Something went wrong..")
                }
                break
                
            case .failure(_):
                break
            }
        }
    }
    
    
}
extension SideMenuListVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSideMenu.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        cell.lblSideNm.text = SideListArr[indexPath.row]
        cell.imgSideList.image = UIImage(named: imgArr[indexPath.row])
        
        
        cell.imgSideList.image = cell.imgSideList.image!.withRenderingMode(.alwaysTemplate)
        cell.imgSideList.tintColor = UIColor.darkGray
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Index = indexPath.row
        
        switch Index
        {
        case 0:
            let todayPatVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PatientListVC") as! PatientListVC
             revealViewController().pushFrontViewController(todayPatVc, animated: true)
            
        
            break
       
    
        case 1:
            let appointVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AppointmentVC") as! AppointmentVC
             revealViewController().pushFrontViewController(appointVc, animated: true)
         
            break
        
        case 2:
            let appointVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "NewsFeedVC") as! NewsFeedVC
            revealViewController().pushFrontViewController(appointVc, animated: true)
            
            break
            
        case 3:
            let videoVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
            revealViewController().pushFrontViewController(videoVc, animated: true)
            break
            
       case 4:
            let profileVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            revealViewController().pushFrontViewController(profileVc, animated: true)
            break
            
//        case 5:
//            let chatVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//           revealViewController().pushFrontViewController(chatVc, animated: true)
//            break
        
        case 5:
            let aboutusVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            revealViewController().pushFrontViewController(aboutusVc, animated: true)
            break
            
        case 6:
            let contactVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
          
             revealViewController().pushFrontViewController(contactVc, animated: true)
            
            break
        
//        case 9:
//            let purchaseVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PurchaseLienceVC") as! PurchaseLienceVC
//            revealViewController().pushFrontViewController(purchaseVc, animated: true)
//            break
            
        case 7:
          
            ZAlertView(title: "Medoc", msg: "Are you sure you want to logout ?", dismisstitle: "No", actiontitle: "Yes")
            {
                self.Logout()
            }
            break
            
        default:
            print("Not match")
        }
        
    }
    
}
