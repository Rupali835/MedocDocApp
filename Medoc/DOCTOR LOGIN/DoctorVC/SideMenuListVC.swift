//
//  TestVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/19/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

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

    @IBOutlet weak var tblSideMenu: UITableView!
    
    var m_cSideList = [SideList]()
    
    var SideListArr = ["Today's Patient", "Profile", "Search Patient", "Add Assistant","Add Report", "Your QR Code", "Chat", "Rate Us", "Contact Us", "Purchases"]
    
    var SideListImg = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSideMenu.delegate = self
        tblSideMenu.dataSource = self
        tblSideMenu.separatorStyle = .none
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Index = indexPath.row
        
        switch Index
        {
        case 0:
            let todayPatVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PatientListVC") as! PatientListVC
            revealViewController()?.pushFrontViewController(todayPatVc, animated: true)
            break
        
       case 1:
            let profileVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            revealViewController()?.pushFrontViewController(profileVc, animated: true)
            break
            
        case 2:
            let searchvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "SearchPatientVC") as! SearchPatientVC
            revealViewController()?.pushFrontViewController(searchvc, animated: true)
            
            break
         
        case 3:
            let addAssistantVc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddAssistantVC") as! AddAssistantVC
            revealViewController()?.pushFrontViewController(addAssistantVc, animated: true)
            
            break
            
        default:
            print("Not match")
        }
        
        
       
        
        
        
    }
    
}
