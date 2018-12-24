//
//  SearchPatientVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/20/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class SearchPatientVC: UIViewController
{

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tblSearchPatient: UITableView!
    
    var toast = JYToast()
    var OldPatientArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblSearchPatient.delegate = self
        tblSearchPatient.dataSource = self
        
        self.tblSearchPatient.separatorStyle = .none
        self.tblSearchPatient.estimatedRowHeight = 150
        self.tblSearchPatient.rowHeight = UITableView.automaticDimension
        
        Oldpatient()
        sideMenus()
        
    }
    
    func Oldpatient()
    {
        let Old_patApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/get_old_patients"
        
        let Param = ["loggedin_id" : "2"]
        
        Alamofire.request(Old_patApi, method: .post, parameters: Param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.OldPatientArr = json["data"] as! [AnyObject]
                    self.tblSearchPatient.reloadData()
                }else{
                    self.toast.isShow("No any patients")
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
    }

    func sideMenus()
    {
        if revealViewController() != nil {
            
            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }

    
    @IBAction func btnBack_onClick(_ sender: Any)
    {
        if revealViewController() != nil
        {
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 130
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}
extension SearchPatientVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OldPatientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSearchPatient.dequeueReusableCell(withIdentifier: "SearchPatientCell", for: indexPath) as! SearchPatientCell
        
        let lcdict = self.OldPatientArr[indexPath.row]
        cell.lblDate.text = lcdict["created_at"] as! String
        cell.lblNm.text = "Name :  \(lcdict["name"] as! String)"
        cell.lblPatID.text = "Patient ID : \(lcdict["patient_id"] as! String)"
        cell.lblPAtDesc.text = lcdict["p_description"] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    
}
