//
//  SearchPatientByContactVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/10/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class SearchPatientByContactVC: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tblSearchPatient: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var patientData = [AnyObject]()
    var toast = JYToast()
    var filtered = NSArray()
    var searchActive = Bool(false)
    var DataArr = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchBar.delegate = self
        
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
        
        self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
        
        print("names = ,\(self.filtered)")
        if(filtered.count == 0)
        {
            searchActive = false
            
        } else {
            searchActive = true
            
        }
        
        self.tblSearchPatient.reloadData()
        
    }

    func fetchdata()
    {
        let searchApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/search_patient"
        let param = ["contact" : searchBar.text!]
        
        Alamofire.request(searchApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.patientData = json["data"] as! [AnyObject]
                    self.DataArr = self.patientData.map ({ $0 }) as NSArray
                    print(self.DataArr)
                    print("empData", self.patientData)
                    self.tblSearchPatient.reloadData()
                }else{
                    self.toast.isShow("Not match")
                }
                break
                
            case .failure(_):
                
                break
            }
        }
    }

}
extension SearchPatientByContactVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive
        {
            return self.filtered.count
        }
        return self.patientData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblSearchPatient.dequeueReusableCell(withIdentifier: "SearchPatientbyContactCell") as! SearchPatientbyContactCell
        
        var lcDict: [String: AnyObject]!
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        }else{
            lcDict = self.patientData[indexPath.row] as! [String: AnyObject]
        }
        
        cell.lblName.text = (lcDict["patient_id"] as! String)
        return cell
    }
    
    
}
