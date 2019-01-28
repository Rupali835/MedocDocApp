//
//  ViewMoreDetailVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class ViewMoreDetailVC: UIViewController
{

    
    @IBOutlet weak var tblInfo: UITableView!
    
    var InfoArr = [String : Any]()
    var toast = JYToast()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let dict = UserDefaults.standard.value(forKey: "PatientDict") as! [String : Any]
        
        let Pid = dict["patient_id"] as! String
        fetchData(pid: Pid)
        
        tblInfo.delegate = self
        tblInfo.dataSource = self
        
        tblInfo.separatorStyle = .none
        
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchData(pid : String)
    {
        let Api = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_patient_info"
        
        let param = ["patient_id" : pid]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    let data = json["data"] as! [AnyObject]
                    
                    self.InfoArr = data[0] as! [String : Any]
                    print(self.InfoArr)
                    DispatchQueue.main.async {
                        self.tblInfo.reloadData()
                    }
                    
                    
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
    }
    

}
extension ViewMoreDetailVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       let lcValuesArr = Array(self.InfoArr.values)
       
        var lcCount = 0
        for lcValues in lcValuesArr
        {
            if let val = lcValues as? String
            {
                lcCount += 1
            }
            
        }
        print("\(lcCount)")
        return lcCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblInfo.dequeueReusableCell(withIdentifier: "PatientInfoCell", for: indexPath) as! PatientInfoCell
        
        //let lcdict = self.InfoArr
        let lcValuesArr = Array(self.InfoArr.values)
        let lcKeysArr = Array(self.InfoArr.keys)
        let lcValue = lcValuesArr[indexPath.row]
        let lcKey = lcKeysArr[indexPath.row]
        
        print("\(lcValue)")
       
        if let val = lcValue as? String
        {
            cell.lblinfo.text = "\(lcKey) : \(val)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
