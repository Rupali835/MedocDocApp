//
//  PatientPrescriptionListVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/16/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class PatientPrescriptionListVC: UIViewController
{

    
//    @IBOutlet weak var btnBlodGrp: UIButton!
   
    
    
    
    @IBOutlet weak var stackOne: UIButton!
    
    @IBOutlet weak var stackSix: UIButton!
    @IBOutlet weak var stackFive: UIButton!
    @IBOutlet weak var stackFour: UIButton!
    @IBOutlet weak var stackThree: UIButton!
    @IBOutlet weak var stackTwo: UIButton!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblPatientId: UILabel!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var PrescriptionListView: UIView!
    @IBOutlet weak var DrawingView: UIView!
    @IBOutlet weak var ReportView: UIView!
    
    @IBOutlet weak var collPrescriptionList: UICollectionView!
  //  @IBOutlet weak var btnContactNo: UIButton!
   
  

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblPatNm: UILabel!
    @IBOutlet weak var imgPatient: UIImageView!
  
    
    var ListArr = [AnyObject]()
    var PatientDict = [String : Any]()
    var patient_id = String()
    var toast = JYToast()
    var dataFromAppoinment = [String : Any]()
    var viewFromAppoinment = Bool()
    var chiefComplainArr = [String : Int]()
  
    var patientInfoArr = [[String : Any]]()
      let image_path = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLbl(lbl: [stackOne, stackTwo, stackThree, stackFour, stackFive, stackSix])
        
        imgPatient.layer.borderWidth = 1.5
        imgPatient.layer.borderColor = UIColor.green.cgColor
        
        btnAdd.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnAdd.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnAdd.layer.shadowOpacity = 1.0
        btnAdd.layer.shadowRadius = 0.0
        btnAdd.layer.masksToBounds = false
        btnAdd.layer.cornerRadius = 4.0
    }
    
    func setDataByVC()
    {
        if viewFromAppoinment == true
        {
            if self.dataFromAppoinment != nil
            {
                self.PrescriptionListView.isHidden = false
            //    showView(b_show: false)
                self.btnAdd.isHidden = true
                self.lblPatNm.text = (self.dataFromAppoinment["name"] as! String)
                let num = self.dataFromAppoinment["contact_no"] as! String
                self.stackFive.setTitle("M: \(num)", for: .normal)
                
                self.patient_id = self.dataFromAppoinment["patient_id"] as! String
                self.lblPatientId.text = "Patient ID: \(self.patient_id)"
                PrescriptionList(id : self.patient_id)
                fetchData(pid: self.patient_id)
            }
        }else{
            
         //   showView(b_show: true)
            
            self.btnAdd.isHidden = false
            PatientDict = UserDefaults.standard.value(forKey: "PatientDict") as! [String : Any]
            if PatientDict.isEmpty == false
            {
                self.lblPatNm.text = PatientDict["name"] as? String
                self.patient_id = PatientDict["patient_id"] as! String
            
                let num = PatientDict["contact_no"] as! String
                self.lblPatientId.text = "Patient ID: \(self.patient_id)"
                self.stackFive.setTitle("M: \(num)", for: .normal)
                PrescriptionList(id : self.patient_id)
                fetchData(pid: self.patient_id)
            }
        }

    }
    
    func setLbl(lbl : [UIButton])
    {
        for Lbl in lbl
        {
            Lbl.layer.borderWidth = 1.5
            Lbl.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        }
      
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
                    
                    let InfoArr = data[0] as! [String : Any]
                   
                   if let Dob = InfoArr["dob"] as? String
                   {
                        let age = calculateAge(dob: Dob)
                    
                self.lblAge.text = "Age: \(age)"
                    
                   }
                  
                    if let img = InfoArr["profile_picture"] as? String
                    {
                        if img != "NF"
                        {
                            let ImgPath = self.image_path + img
                            let imgUrl = URL(string: ImgPath)
                            self.imgPatient.kf.setImage(with: imgUrl)
                        }else
                        {
                            self.imgPatient.image = UIImage(named: "signuser")
                        }
                    }
                    else
                    {
                        self.imgPatient.image = UIImage(named: "signuser")
                    }
                
                  self.patientInfoArr.removeAll(keepingCapacity: false)
                    
                    for (key, lcVal) in InfoArr
                    {
                        var lcdict = [String : String]()
                        
                        if let Strval = lcVal as? String
                        {
                            if ((Strval != "NF") && (Strval != "0") && (Strval != ""))
                            {
                                lcdict[key] = Strval
                                self.patientInfoArr.append(lcdict)
                            }
                        }
                    }
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
    }
    
    @IBAction func btnViewMore_onclick(_ sender: Any)
    {
        let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ViewMoreDetailVC") as! ViewMoreDetailVC
        detailvc.ChiefComplainARR = self.chiefComplainArr
        self.navigationController?.pushViewController(detailvc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       setDataByVC()
        collPrescriptionList.delegate = self
        collPrescriptionList.dataSource = self
    }
    
    func showView(b_show : Bool)
    {
        self.PrescriptionListView.isHidden = b_show
        self.ReportView.isHidden = b_show
        self.DrawingView.isHidden = b_show
        self.firstLine.isHidden = b_show
        self.secondLine.isHidden = b_show
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
                    var chiefProbArr = [String]()
                    
                    self.PrescriptionListView.isHidden = false
                   self.ListArr = json["data"] as! [AnyObject]
                    
                    self.chiefComplainArr.removeAll(keepingCapacity: false)
                    
                    for lcPatProb in self.ListArr
                    {
                        let paProb = lcPatProb["patient_problem"] as! String
                        
                       chiefProbArr.append(paProb)
                        
                    }
                    
                    let mapItem =  chiefProbArr.map {($0, 1)}
                    
                    self.chiefComplainArr = Dictionary(mapItem, uniquingKeysWith: +)
                    
                self.collPrescriptionList.reloadData()
                }
                
                if Msg == "fail"
                {
                     self.toast.isShow("Something went wrong")
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

extension PatientPrescriptionListVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.ListArr.count != 0
        {
            return self.ListArr.count
        }else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collPrescriptionList.dequeueReusableCell(withReuseIdentifier: "PatientPrescriptionListCell", for: indexPath) as! PatientPrescriptionListCell
        
        let lcdict = self.ListArr[indexPath.row]
        cell.lblDate.text = (lcdict["created_at"] as! String)
        let ptProb = (lcdict["patient_problem"] as! String)
        
        cell.lblPatproblem.text = "Chief Complain: \(ptProb)"
        cell.backView.designCell()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "DetailPrescriptionVC") as! DetailPrescriptionVC
        
        let lcdict = self.ListArr[indexPath.row]
        detailvc.PatientInfo = lcdict as! [String : Any]
        self.present(detailvc, animated: true, completion: nil)
    }
    
}

