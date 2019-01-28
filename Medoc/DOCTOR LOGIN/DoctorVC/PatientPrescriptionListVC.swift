//
//  PatientPrescriptionListVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/16/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class PatientPrescriptionListVC: UIViewController
{

    
    @IBOutlet weak var btnContactNo: UIButton!
    @IBOutlet weak var btnDob: UIButton!
    @IBOutlet weak var btnviewmore: UIButton!

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblPatNm: UILabel!
    @IBOutlet weak var imgPatient: UIImageView!
    @IBOutlet weak var tblPrescriptionList: UITableView!
    
    var ListArr = [AnyObject]()
    var PatientDict = [String : Any]()
    var patient_id = String()
    var toast = JYToast()
    var dataFromAppoinment = [String : Any]()
    
    var viewFromAppoinment = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLbl(lbl: [btnDob, btnContactNo, btnviewmore])
        
        imgPatient.layer.borderWidth = 1.5
        imgPatient.layer.borderColor = UIColor.green.cgColor
        
        tblPrescriptionList.delegate = self
        tblPrescriptionList.dataSource = self
        tblPrescriptionList.separatorStyle = .none
        
        btnAdd.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnAdd.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnAdd.layer.shadowOpacity = 1.0
        btnAdd.layer.shadowRadius = 0.0
        btnAdd.layer.masksToBounds = false
        btnAdd.layer.cornerRadius = 4.0
    }
    
    func setLbl(lbl : [UIButton])
    {
        for Lbl in lbl
        {
            Lbl.layer.borderWidth = 1.5
            Lbl.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        }
      
    }
    
    @IBAction func btnViewMore_onclick(_ sender: Any)
    {
        let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ViewMoreDetailVC") as! ViewMoreDetailVC
        self.present(detailvc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if viewFromAppoinment == true
        {
            if self.dataFromAppoinment != nil
            {
                self.btnAdd.isHidden = true
                self.lblPatNm.text = (self.dataFromAppoinment["name"] as! String)
                let num = self.dataFromAppoinment["contact_no"] as! String
                self.btnContactNo.setTitle(num, for: .normal)
                
                self.patient_id = self.dataFromAppoinment["patient_id"] as! String
                PrescriptionList(id : self.patient_id)
            }
        }else{
            
            self.btnAdd.isHidden = false
              PatientDict = UserDefaults.standard.value(forKey: "PatientDict") as! [String : Any]
            if PatientDict.isEmpty != nil
            {
                self.lblPatNm.text = PatientDict["name"] as? String
                self.patient_id = PatientDict["patient_id"] as! String
                let num = PatientDict["contact_no"] as! String
                self.btnContactNo.setTitle(num, for: .normal)
                PrescriptionList(id : self.patient_id)
                
            }
        }

    }
    
    func PrescriptionList(id : String)
    {
        let listApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/list_of_prescription"
        
        let param = ["patient_id" : id]
        
        Alamofire.request(listApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                   self.ListArr = json["data"] as! [AnyObject]
                   self.tblPrescriptionList.reloadData()
                }
                
                if Msg == "fail"
                {
                    
                }
                
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPresc_onclick(_ sender: Any)
    {
        let presvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AndriodPrescFormVC") as! AndriodPrescFormVC
        
            presvc.PatientdataFromBack = PatientDict
        
        self.navigationController?.pushViewController(presvc, animated: true)
    }
    
}
extension PatientPrescriptionListVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ListArr != nil
        {
            return self.ListArr.count
        }else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblPrescriptionList.dequeueReusableCell(withIdentifier: "PatientPrescriptionListCell", for: indexPath) as! PatientPrescriptionListCell
        
        let lcdict = self.ListArr[indexPath.row]
        cell.lblDate.text = lcdict["created_at"] as! String
        cell.lblPatproblem.text = lcdict["patient_problem"] as! String
        cell.backView.designCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "DetailPrescriptionVC") as! DetailPrescriptionVC
        
        let lcdict = self.ListArr[indexPath.row]
        detailvc.PatientInfo = lcdict as! [String : Any]
        self.present(detailvc, animated: true, completion: nil)
    }
}
