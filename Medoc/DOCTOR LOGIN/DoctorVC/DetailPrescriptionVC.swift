//
//  DetailPrescriptionVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/17/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

// image path = http://www.otgmart.com/medoc/medoc_doctor_api/uploads/1291547720552065.jpg

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD

class DetailPrescriptionVC: UIViewController {

    
    @IBOutlet weak var lblChiefComplain: UILabel!
    
    @IBOutlet weak var totalHgtofmainView: NSLayoutConstraint!
    @IBOutlet weak var viewMedicine: UIView!
    @IBOutlet weak var viewReportImg: UIView!
    @IBOutlet weak var viewDrawingImg: UIView!
    @IBOutlet weak var viewPrescImges: UIView!
    @IBOutlet weak var HgtReportImges: NSLayoutConstraint!
    @IBOutlet weak var HgtPatientDrawingImges: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoOE: UILabel!
    
    @IBOutlet weak var lblNoDrawingImg: UILabel!
    @IBOutlet weak var lblNoOEimges: UILabel!
    @IBOutlet weak var HgtPrescriptionImages: NSLayoutConstraint!
    
    @IBOutlet weak var lblNoOtherDetail: UILabel!
    @IBOutlet weak var lblNoMedicine: UILabel!
    @IBOutlet weak var lblNoReportImg: UILabel!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var prescImgColl: UICollectionView!
    @IBOutlet weak var repoetImgColl: UICollectionView!
    @IBOutlet weak var patientDrawingImgColl: UICollectionView!
    @IBOutlet weak var lblNoLabTest: UILabel!
    @IBOutlet weak var txtLabTest: UITextView!
    @IBOutlet weak var medicineCollectionView: UICollectionView!
    @IBOutlet weak var txtPrescdetail: UITextView!
    @IBOutlet weak var txtTemp: HoshiTextField!
    @IBOutlet weak var txtOtherdetail: UITextView!
    @IBOutlet weak var txtBloodGroup: HoshiTextField!
    @IBOutlet weak var txtWeight: HoshiTextField!
    @IBOutlet weak var txtHeight: HoshiTextField!
    
    var toast = JYToast()
    var PrescDetail = [AnyObject]()
    var MedicineArr = [AnyObject]()
    var ReportDetailArr = [AnyObject]()
    
    var drawingImgArr = [AnyObject]()
  //  var reportImgArr = [AnyObject]()
    var PrescImgArray = [AnyObject]()
    var StringURL : String!
    var pres_pdf : String!
    var PatientId = String()
    var pdfName = String()
    var ReportArr = [[String: AnyObject]]()
 

    
    let image_path = "http://medoc.co.in/medoc_doctor_api/uploads/"
    
    let pdf_path = "http://medoc.co.in/medoc_doctor_api/prescription_pdf/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.userInteraction()
    
        if self.PatientId != nil
        {
            detailPresc(id : self.PatientId)
        }
       setDelegate()
    }
    
    func userInteraction()
    {
        txtTemp.isUserInteractionEnabled = false
        txtHeight.isUserInteractionEnabled = false
        txtWeight.isUserInteractionEnabled = false
        txtPrescdetail.isUserInteractionEnabled = false
        txtOtherdetail.isUserInteractionEnabled = false
        txtBloodGroup.isUserInteractionEnabled = false
    }
    
    func setDelegate()
    {
        prescImgColl.delegate = self
        prescImgColl.dataSource = self
        
        repoetImgColl.delegate = self
        repoetImgColl.dataSource = self
        
        patientDrawingImgColl.delegate = self
        patientDrawingImgColl.dataSource = self
        
        medicineCollectionView.dataSource = self
        medicineCollectionView.delegate = self
    }
    
    func detailPresc(id : String)
    {
       // let detailpresApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/detail_prescription"
        
        let detailpresApi = Constant.BaseUrl+Constant.detail_prescription_of_patient
        let param = ["id" : id]
        
        Alamofire.request(detailpresApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    //self.pres_pdf = json["prescription_pdf"] as! String
                    self.PrescDetail = json["prescriptions"] as! [AnyObject]
                    self.setDataToText(Arr: self.PrescDetail)
                    
                    self.ReportDetailArr = json["reports"] as! [AnyObject]
                    self.MedicineArr = json["medicines"] as! [AnyObject]
                    
                    if self.ReportDetailArr.isEmpty == false
                    {
                        self.setReportData(Arr: self.ReportDetailArr)
                    }else{
                        self.lblNoReportImg.isHidden = false
                        self.HgtReportImges.constant = 120
                    }
                    
                    if self.MedicineArr.isEmpty == false
                    {
                        self.lblNoMedicine.isHidden = true
                        self.medicineCollectionView.reloadData()
                    }else
                    {
                        self.lblNoMedicine.isHidden = false
                    }
                }
                
                break
            case .failure(_):
                break
            }
        }
        
    }
    
    func setDataToText(Arr : [AnyObject])
    {
        for lcdata in Arr
        {
            self.pdfName = (lcdata["prescription_pdf"] as? String)!
            self.PatientId = (lcdata["patient_id"] as? String)!
            self.txtBloodGroup.text = lcdata["temperature"] as? String
            self.txtTemp.text = lcdata["blood_pressure"] as? String
            self.txtHeight.text = (lcdata["height"] as! String)
            self.txtWeight.text = (lcdata["weight"] as! String)
            self.lblChiefComplain.text = (lcdata["patient_problem"] as! String)
           
             let labTestNm = lcdata["lab_test"] as? String
             if labTestNm != "NF"
             {
                self.txtLabTest.text = labTestNm
                self.lblNoLabTest.isHidden = true
            }else
             {
                self.txtLabTest.text = ""
                self.lblNoLabTest.isHidden = false
            }
            
            let presOE = (lcdata["prescription_details"] as! String)
            if presOE != "NF"
            {
                 self.txtPrescdetail.text = presOE
                self.lblNoOE.isHidden = true
            }else
            {
                self.txtPrescdetail.text = ""
                self.lblNoOE.isHidden = false
            }
            
            self.txtOtherdetail.text = (lcdata["other_details"] as! String)
            
            let otherDetailTxt = (lcdata["other_details"] as! String)
            
            if otherDetailTxt != "NF"
            {
                self.txtOtherdetail.text = otherDetailTxt
                self.lblNoOtherDetail.isHidden = true
            }else
            {
                self.txtOtherdetail.text = ""
                 self.lblNoOtherDetail.isHidden = false
            }
            
            
            let DrawingImg = lcdata["drawing_image"] as! String
            
            if (DrawingImg != "NF") && (DrawingImg != "[]")
            {
                 lblNoDrawingImg.isHidden = true
                  self.drawingImgArr = getArrayFromJSonString(cJsonStr: DrawingImg)
                  self.drawingImgArr = getArrayFromJSonString(cJsonStr: DrawingImg)
                  patientDrawingImgColl.reloadData()
            }else
            {
                lblNoDrawingImg.isHidden = false
                self.HgtPatientDrawingImges.constant = 120
            }
            
            
            let HandwritenImg = lcdata["handwritten_image"] as! String

            if (HandwritenImg != "NF") && (HandwritenImg != "[]")
            {
                 lblNoOEimges.isHidden = true
                 self.PrescImgArray = getArrayFromJSonString(cJsonStr: HandwritenImg)
                
                  self.HgtPrescriptionImages.constant = 350
                   prescImgColl.reloadData()
            }else{
                
                lblNoOEimges.isHidden = false
                self.HgtPrescriptionImages.constant = 120
            }
            
            let signimg = lcdata["signature_image"] as! String
            let ImgPath = image_path + signimg
            let ImgURL = URL(string: ImgPath)
            self.imgSign.kf.setImage(with: ImgURL)
        }
    }
    
    func setReportData(Arr : [AnyObject])
    {
 
        self.ReportArr.removeAll(keepingCapacity: false)
        Arr.forEach { lcArr in
            
            let report_imgNm = lcArr["image_name"] as! String
            
            if (report_imgNm != "NF") && (report_imgNm != "[]")
            {
                self.getArrayFromJSonString(mcJsonStr: report_imgNm).forEach { lcDict in
                    self.ReportArr.append(lcDict)
                }
            }

        }
         if self.ReportArr.count != 0
            {
                lblNoReportImg.isHidden = true
                self.HgtReportImges.constant = 350
                self.repoetImgColl.reloadData()
            }else{
                lblNoReportImg.isHidden = false
                self.HgtReportImges.constant = 120
          }
        
    }
    
    func getArrayFromJSonString(mcJsonStr: String)->[[String: AnyObject]]
    {
        let jsonData = mcJsonStr.data(using: .utf8)!
        
        guard let lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: AnyObject]] else {
            return [["Data": "No Found"]] as [[String: AnyObject]]
        }
        
        return lcArrData
    }

    func getArrayFromJSonString(cJsonStr: String)->[AnyObject]
    {
        let jsonData = cJsonStr.data(using: .utf8)!
        
        guard let lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [AnyObject] else {
            return ["No Found" as AnyObject]
        }
        return lcArrData
    }
    
    @IBAction func btnDownloadPdf_onclick(_ sender: Any)
    {
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "Downloading Prescription..")
            
        }
        
          let downloadurl = "\(pdf_path)\(self.PatientId)\("/")\(self.pdfName)"
        
//        let pdfvc = self.storyboard?.instantiateViewController(withIdentifier: "PdfReaderVC") as! PdfReaderVC
//
//        pdfvc.UrlStr = downloadurl
//        self.present(pdfvc, animated: true, completion: nil)
//        OperationQueue.main.addOperation {
//            SVProgressHUD.dismiss()
        
    //    }
        
     
        let urlString: String! = (downloadurl as AnyObject).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL: NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            print("DocumentURl: = ",documentsURL)
            let fileURL = documentsURL.appendingPathComponent("0.pdf")
            print("fileURl =", fileURL as Any)
            return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination).response
            { response in
                print(response)
                
                if response.error == nil, let filePath = response.destinationURL?.path
                {
                    print("mmm",filePath)
                    self.StringURL = filePath
                    
                    OperationQueue.main.addOperation {
                        SVProgressHUD.dismiss()
                        
                    }
                    
                    let pdfvc = self.storyboard?.instantiateViewController(withIdentifier: "PdfReaderVC") as! PdfReaderVC
                    
                    pdfvc.UrlStr = self.StringURL
                    self.present(pdfvc, animated: true, completion: nil)
                }
        }
        
    }
 
    @IBAction func btnback_onclick(_ sender: Any)
    {
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension DetailPrescriptionVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == prescImgColl
        {
            return self.PrescImgArray.count
            
        }else if collectionView == patientDrawingImgColl
        {
            return self.drawingImgArr.count
            
        }else if collectionView == repoetImgColl
        {
            return self.ReportArr.count
        }else if collectionView == medicineCollectionView
        {
            return self.MedicineArr.count
        }else
        {
            return 0
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == prescImgColl
        {
            let Pcell = prescImgColl.dequeueReusableCell(withReuseIdentifier: "CellPrescImages", for: indexPath) as! CellPrescImages
        
            if self.PrescImgArray.count != 0
            {
                let lcdict = self.PrescImgArray[indexPath.row]
                
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
                let Imgurl = URL(string: ImgPath)
                Pcell.imgpresc.kf.setImage(with: Imgurl)
                Pcell.lblprescnm.text = "Page \(indexPath.row + 1)"
              
                Pcell.backview.designCell()
            }
            
            return Pcell
            
        }else if collectionView == patientDrawingImgColl
        {
            let Dcell = patientDrawingImgColl.dequeueReusableCell(withReuseIdentifier: "CellDrawingImages", for: indexPath) as! CellDrawingImages
            
            if self.drawingImgArr.count != 0
            {
                
                let lcdict = self.drawingImgArr[indexPath.row]
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
                let Imgurl = URL(string: ImgPath)
                Dcell.imgDrawing.kf.setImage(with: Imgurl)
                Dcell.lblnm.text = lcdict["dataTag"] as! String
                Dcell.backView.designCell()
            }
          
            return Dcell
            
         }else if collectionView == repoetImgColl
          {
            let Rcell = repoetImgColl.dequeueReusableCell(withReuseIdentifier: "CellReportImages", for: indexPath) as! CellReportImages
            
            if self.ReportArr.count != 0
            {
                
                let lcdict = self.ReportArr[indexPath.row]
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
                let Imgurl = URL(string: ImgPath)
                Rcell.imgReport.kf.setImage(with: Imgurl)
                Rcell.lblReportNm.text = lcdict["dataTag"] as? String
                Rcell.backview.designCell()
            }
          
            return Rcell

        }
        else if collectionView == medicineCollectionView
        {
            let Mcell = medicineCollectionView.dequeueReusableCell(withReuseIdentifier: "CellMedicineData", for: indexPath) as! CellMedicineData
           
            if self.MedicineArr.count != 0
            {
                
                let dict = self.MedicineArr[indexPath.row]
                Mcell.lblmedNm.text = dict["medicine_name"] as? String
                Mcell.backview.designCell()
                
                var FirstTimeOfMed = String()
                var SecondTimeOfMed = String()
                var ThirdTimeOfMed = String()
                
                let bfBrk = dict["before_bf"] as? String
                let afBrk = dict["after_bf"] as? String
                let bfLunch = dict["before_lunch"] as? String
                let afLunch = dict["after_lunch"] as? String
                let bfDinner = dict["before_dinner"] as? String
                let afDinner = dict["after_dinner"] as? String
                
                if bfBrk == "1" || afBrk == "1"
                {
                    FirstTimeOfMed = "1-"
                }else
                {
                    FirstTimeOfMed = "0-"
                }
                
                if bfLunch == "1" || afLunch == "1"
                {
                    SecondTimeOfMed = "1-"
                }else{
                    SecondTimeOfMed = "0-"
                }
                
                if bfDinner == "1" || afDinner == "1"
                {
                    ThirdTimeOfMed = "1"
                }else{
                    ThirdTimeOfMed = "0"
                }
                let medtime = FirstTimeOfMed + SecondTimeOfMed + ThirdTimeOfMed
                Mcell.lblMedTime.text = medtime
                
            }
         
            return Mcell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if collectionView == prescImgColl
        {
            if self.PrescImgArray.count != 0
            {
                let lcdict = self.PrescImgArray[indexPath.row]
                
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
               
                var appstory = AppStoryboard.Doctor
                if UIDevice.current.userInterfaceIdiom == .pad {
                    appstory = AppStoryboard.Doctor
                } else {
                    appstory = AppStoryboard.IphoneDoctor
                }
               let vc = appstory.instance.instantiateViewController(withIdentifier: "OpenImageInWeb") as! OpenImageInWeb
                
                vc.image_name = ImgPath
                self.navigationController?.pushViewController(vc, animated: true)
            
            }
        }
        
        if collectionView == repoetImgColl
        {
            if self.ReportArr.count != 0
            {
                
                let lcdict = self.ReportArr[indexPath.row]
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
                
                var appstory = AppStoryboard.Doctor
                if UIDevice.current.userInterfaceIdiom == .pad {
                    appstory = AppStoryboard.Doctor
                } else {
                    appstory = AppStoryboard.IphoneDoctor
                }
                let vc = appstory.instance.instantiateViewController(withIdentifier: "OpenImageInWeb") as! OpenImageInWeb
                
                vc.image_name = ImgPath
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
        }
        
        if collectionView == patientDrawingImgColl
        {
            if self.drawingImgArr.count != 0
            {
                
                let lcdict = self.drawingImgArr[indexPath.row]
                let Img = lcdict["dataName"] as! String
                let ImgPath = image_path + Img
               
                var appstory = AppStoryboard.Doctor
                if UIDevice.current.userInterfaceIdiom == .pad {
                    appstory = AppStoryboard.Doctor
                } else {
                    appstory = AppStoryboard.IphoneDoctor
                }
                let vc = appstory.instance.instantiateViewController(withIdentifier: "OpenImageInWeb") as! OpenImageInWeb
                
                vc.image_name = ImgPath
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
