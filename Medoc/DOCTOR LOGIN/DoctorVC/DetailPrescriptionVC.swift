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

    
    
    @IBOutlet weak var totalHgtofmainView: NSLayoutConstraint!
    @IBOutlet weak var viewMedicine: UIView!
    @IBOutlet weak var viewReportImg: UIView!
    @IBOutlet weak var viewDrawingImg: UIView!
    @IBOutlet weak var viewPrescImges: UIView!
    @IBOutlet weak var HgtReportImges: NSLayoutConstraint!
    @IBOutlet weak var HgtPatientDrawingImges: NSLayoutConstraint!
    
    @IBOutlet weak var HgtPrescriptionImages: NSLayoutConstraint!
    
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var prescImgColl: UICollectionView!
    @IBOutlet weak var repoetImgColl: UICollectionView!
    @IBOutlet weak var patientDrawingImgColl: UICollectionView!
   
    
    @IBOutlet weak var medicineCollectionView: UICollectionView!
    
    @IBOutlet weak var txtPrescdetail: UITextView!
    @IBOutlet weak var txtTemp: HoshiTextField!
    
    @IBOutlet weak var txtOtherdetail: UITextView!
    @IBOutlet weak var txtBloodGroup: HoshiTextField!
    
    @IBOutlet weak var txtWeight: HoshiTextField!
    @IBOutlet weak var txtHeight: HoshiTextField!
    var toast = JYToast()
    var PatientInfo = [String : Any]()
    var PrescDetail = [AnyObject]()
    var MedicineArr = [AnyObject]()
    var ReportDetailArr = [AnyObject]()
    
    var drawingImgArr = [AnyObject]()
    var reportImgArr = [AnyObject]()
    var PrescImgArray = [AnyObject]()
    var StringURL : String!
    var pres_pdf : String!
    var PatientId = String()
    var pdfName = String()
    
    let image_path = "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/"
    
    let pdf_path = "http://www.otgmart.com/medoc/medoc_doctor_api/prescription_pdf/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    if PatientInfo != nil
    {
        print(PatientInfo)
        let Id = self.PatientInfo["id"] as! String
        detailPresc(id : Id)
    }
      
    setDelegate()
        
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
        let detailpresApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/detail_prescription"
        
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
                    }
                    
                    if self.MedicineArr.isEmpty == false
                    {
                        self.medicineCollectionView.reloadData()
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
            self.txtPrescdetail.text = (lcdata["prescription_details"] as! String)
            self.txtOtherdetail.text = (lcdata["other_details"] as! String)
            
            let DrawingImg = lcdata["drawing_image"] as! String
            
            if DrawingImg != "NF"
            {
                  self.drawingImgArr = getArrayFromJSonString(cJsonStr: DrawingImg)
                  self.drawingImgArr = getArrayFromJSonString(cJsonStr: DrawingImg)
                  patientDrawingImgColl.reloadData()
            }else
            {
                 self.HgtPatientDrawingImges.constant = 120
            }
            
            
            let HandwritenImg = lcdata["handwritten_image"] as! String

            if HandwritenImg != "NF"
            {
                 self.PrescImgArray = getArrayFromJSonString(cJsonStr: HandwritenImg)
                
                  self.HgtPrescriptionImages.constant = 350
                   prescImgColl.reloadData()
            }else{
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
       for lcArr in Arr
       {
            let report_imgNm = lcArr["image_name"] as! String
        
            if report_imgNm != "NF"
            {
                self.reportImgArr = getArrayFromJSonString(cJsonStr: report_imgNm)
                self.HgtReportImges.constant = 350
                repoetImgColl.reloadData()
            }else
            {
                 self.HgtReportImges.constant = 120
            }
        }
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
        
        let pdfvc = self.storyboard?.instantiateViewController(withIdentifier: "PdfReaderVC") as! PdfReaderVC
        
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
        self.dismiss(animated: true, completion: nil)
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
            return self.reportImgArr.count
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
            
            if self.reportImgArr.count != 0
            {
                
                let lcdict = self.reportImgArr[indexPath.row]
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
    
    
}
