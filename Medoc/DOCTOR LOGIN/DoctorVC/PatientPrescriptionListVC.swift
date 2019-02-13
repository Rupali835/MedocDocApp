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
    
    @IBOutlet weak var collDrawings: UICollectionView!
    @IBOutlet weak var collReports: UICollectionView!
    @IBOutlet weak var collPrescriptionList: UICollectionView!
  //  @IBOutlet weak var btnContactNo: UIButton!
   
  

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblPatNm: UILabel!
    @IBOutlet weak var imgPatient: UIImageView!
  
    var DrawingArr = [[String: AnyObject]]()
    var MedicineArr = [AnyObject]()
    var ReportArr = [[String: AnyObject]]()
    var ListArr = [AnyObject]()
    var PatientDict = [String : Any]()
    var patient_id = String()
    var toast = JYToast()
    var dataFromAppoinment = [String : Any]()
    var viewFromAppoinment = Bool()
    var chiefComplainArr = [String : Int]()
    var loggedinId = Int()
    var cOpenPopup : OpenPopUpInfoVC!
    var PatientBasicInfo = [String : Any]()
  
    let image_path = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/"
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        setLbl(lbl: [stackOne, stackTwo, stackThree, stackFour, stackFive, stackSix])
        
        imgPatient.layer.borderWidth = 1.5
        imgPatient.layer.borderColor = UIColor.green.cgColor
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        
        self.loggedinId = (dict["id"] as? Int)!
    }
    
    override func awakeFromNib()
    {
        self.cOpenPopup = (AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "OpenPopUpInfoVC") as! OpenPopUpInfoVC)
    }
    
    @IBAction func btnEmrgData_onCick(_ sender: Any)
    {
        self.cOpenPopup.view.frame = self.view.frame
        
        self.cOpenPopup.setData(info: self.PatientBasicInfo, val: 1)
        
//        self.cOpenPopup.checkData = 1
//        self.cOpenPopup.PatientInfo = self.PatientBasicInfo
        self.view.addSubview(self.cOpenPopup.view)
        self.cOpenPopup.view.clipsToBounds = true
    }
    
    @IBAction func btnBasicInfo_onClick(_ sender: Any)
    {
        self.cOpenPopup.view.frame = self.view.frame
        self.cOpenPopup.setData(info: self.PatientBasicInfo, val: 2)
//        self.cOpenPopup.checkData = 2
//        self.cOpenPopup.PatientInfo = self.PatientBasicInfo
        self.view.addSubview(self.cOpenPopup.view)
        self.cOpenPopup.view.clipsToBounds = true
    }
    
    @IBAction func btnMedicalCondition_onClick(_ sender: Any)
    {
        self.cOpenPopup.view.frame = self.view.frame
        self.cOpenPopup.setData(info: self.PatientBasicInfo, val: 3)
//        self.cOpenPopup.checkData = 3
//        self.cOpenPopup.PatientInfo = self.PatientBasicInfo
        self.view.addSubview(self.cOpenPopup.view)
        self.cOpenPopup.view.clipsToBounds = true
    }
    
    
    func setDataByVC()
    {
        if viewFromAppoinment == true
        {
            if self.dataFromAppoinment != nil
            {
                self.PrescriptionListView.isHidden = false
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
                    
                    self.PatientBasicInfo = data[0] as! [String : Any]
                   
                   if let Dob = self.PatientBasicInfo["dob"] as? String
                   {
                        let age = calculateAge(dob: Dob)
                    
                self.lblAge.text = "Age: \(age)"
                    
                   }
                  
                    if let img = self.PatientBasicInfo["profile_picture"] as? String
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
        
        if self.chiefComplainArr.count != 0
        {
             detailvc.ChiefComplainARR = self.chiefComplainArr
        }
         self.navigationController?.pushViewController(detailvc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       setDataByVC()
       setDelegate()
    }
    
    func setDelegate()
    {
        collPrescriptionList.delegate = self
        collPrescriptionList.dataSource = self
        collReports.delegate = self
        collReports.dataSource = self
        collDrawings.delegate = self
        collDrawings.dataSource = self
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
        let listApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_prescription_list_by_patient_id"
        
        var Param = Parameters()
        
        if viewFromAppoinment == true
        {
             Param = ["patient_id" : id,
                         "loggedin_id" : self.loggedinId]
        }
        else
        {
            Param = ["patient_id" : id]
        }
      
        print(Param)
        
        Alamofire.request(listApi, method: .post, parameters: Param).responseJSON { (resp) in
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
            self.ListArr = json["prescriptions"] as! [AnyObject]
                   
            self.setDataToText(Arr: self.ListArr)
                    
            let ReportData = json["reports"] as! [AnyObject]
                    
            self.setReportData(Arr: ReportData)
                    
            self.MedicineArr = json["medicines"] as! [AnyObject]
                    
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
    
    func getArrayFromJSonString(cJsonStr: String)->[[String: AnyObject]]
    {
        let jsonData = cJsonStr.data(using: .utf8)!
        
        guard var lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: AnyObject]] else {
            return [["Data": "No Found"]] as [[String: AnyObject]]
        }
        
        return lcArrData
    }
    
    func setDataToText(Arr : [AnyObject])
    {
        self.DrawingArr.removeAll(keepingCapacity: false)
       Arr.forEach { lcArr in
            
            let report_imgNm = lcArr["drawing_image"] as! String
            //let lcID = lcArr["id"] as! String
        
            if (report_imgNm != "NF") && (report_imgNm != "[]")
            {
               self.getArrayFromJSonString(cJsonStr: report_imgNm).forEach { lcDict in
               
                var lcNewDic = [String: AnyObject]()
                lcNewDic = lcDict
                lcNewDic["id"] = lcArr["id"] as AnyObject
                self.DrawingArr.append(lcNewDic)
                    
                    collDrawings.reloadData()
                }
            }
        }
        
    }
    
    func setReportData(Arr : [AnyObject])
    {
        self.ReportArr.removeAll(keepingCapacity: false)
        Arr.forEach { lcArr in
            
           let report_imgNm = lcArr["image_name"] as! String
            
            if (report_imgNm != "NF") && (report_imgNm != "[]")
            {
                
                self.getArrayFromJSonString(cJsonStr: report_imgNm).forEach { lcDict in
                    self.ReportArr.append(lcDict)
                    
                    collReports.reloadData()
                }
            }
        }
   }
}

extension PatientPrescriptionListVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collPrescriptionList
        {
            return self.ListArr.count
            
        }else if collectionView == collReports
        {
            return self.ReportArr.count
            
        }else if collectionView == collDrawings
        {
           return self.DrawingArr.count
        }else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == collPrescriptionList
        {
            let cell = collPrescriptionList.dequeueReusableCell(withReuseIdentifier: "PatientPrescriptionListCell", for: indexPath) as! PatientPrescriptionListCell
            
            let lcdict = self.ListArr[indexPath.row]
            cell.lblDate.text = (lcdict["created_at"] as! String)
            let ptProb = (lcdict["patient_problem"] as! String)
            
            cell.lblPatproblem.text = "Chief Complain: \(ptProb)"
            cell.backView.designCell()
            return cell
        }
        else if collectionView == collReports
        {
           let Rcell = collReports.dequeueReusableCell(withReuseIdentifier: "PatientReportListCell", for: indexPath) as! PatientReportListCell
            
            let lcdict = self.ReportArr[indexPath.row]
            let Img = lcdict["dataName"] as! String
            let ImgPath = image_path + Img
            let Imgurl = URL(string: ImgPath)
            Rcell.imgReport.kf.setImage(with: Imgurl)
            Rcell.backView.designCell()
            
            return Rcell
        }
            
        else if collectionView == collDrawings
        {
            let Dcell = collDrawings.dequeueReusableCell(withReuseIdentifier: "PatientDrawingListCell", for: indexPath) as! PatientDrawingListCell
            
            let lcdict = self.DrawingArr[indexPath.row]
            let Img = lcdict["dataName"] as! String
            let ImgPath = image_path + Img
            let Imgurl = URL(string: ImgPath)
            Dcell.imgDrawing.kf.setImage(with: Imgurl)
            Dcell.backview.designCell()
            
            return Dcell
        }
        else
        {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if collectionView == collPrescriptionList
        {
            let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "DetailPrescriptionVC") as! DetailPrescriptionVC
            
            let lcdict = self.ListArr[indexPath.row]
            detailvc.PatientInfo = lcdict as! [String : Any]
            self.navigationController?.pushViewController(detailvc, animated: true)
          //  self.present(detailvc, animated: true, completion: nil)
        }
        
        if collectionView == collReports
        {
            let lcdict = self.ReportArr[indexPath.row]
            let Img = lcdict["dataName"] as! String
            let ImgPath = image_path + Img
            
            let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "OpenImageInWeb") as! OpenImageInWeb
            
            vc.image_name = ImgPath
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        if collectionView == collDrawings
        {
             let detailvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "DetailPrescriptionVC") as! DetailPrescriptionVC
            
            let lcdict = self.DrawingArr[indexPath.row]
            detailvc.PatientInfo = lcdict as [String : Any]
            
            self.navigationController?.pushViewController(detailvc, animated: true)
        }
      
    }
    
}

