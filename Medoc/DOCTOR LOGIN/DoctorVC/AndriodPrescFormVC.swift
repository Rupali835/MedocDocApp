//
//  AndriodPrescFormVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/3/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import ZAlertView
import SkyFloatingLabelTextField

class SignatureData {
    var SignatureImgName: String
    var SignatureImg: UIImage!
    
    init(cSignatureImgName: String, cSignatureImg: UIImage) {
        self.SignatureImgName = cSignatureImgName
        self.SignatureImg     = cSignatureImg
    }
}

class PresData
{
    var patient_id : String!
    var temprature : String!
    var weight : String!
    var height : String!
    var blood_group : String!
    var other_details : String!
    var refered_by : String!
    var handwritten_image : String!  //patient drawing images
    var patient_problem : String!
    var drawing_image : String!  // Click here to draw presc btn
    var signature_image : String!
    var images : [UIImage]!
    var medicine_data : String!
    var image_name : String!    // Report image with tag
    var followup_date : String!
    var prescription_details : String!
  
}

class MedicineData
{
    var patientId : String!
    var medicineName : String!
    var intervalType : Int!   //daily=1, weekly=2, time interval=3
    var intervalPeriod : String!  // how many days
    var intervalTime : String!    // how many weeks
    var beforeBreakfast : String!
    var beforeBreakfastTime : String!
    var afterBreakfast : String!
    var afterBreakfastTime : String!
    var beforeLunch : String!
    var beforeLunchTime : String!
    var afterLunch : String!
    var afterLunchTime : String!
    var beforeDinner : String!
    var beforeDinnerTime : String!
    var afterDinner : String!
    var afterDinnerTime : String!
 }

class AndriodPrescFormVC: UIViewController, signProtocol, drawingOnBack, reportImgDelegate, UITextViewDelegate, DrawingOnPadProtocol,PaintDocsDelegate
{
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMedicineTiming : UILabel!
    @IBOutlet weak var detailBtnOK: UIButton!
    @IBOutlet weak var detailMedicineWeeks: UILabel!
    @IBOutlet weak var detailMedicineDays: UILabel!
    @IBOutlet weak var detailMedicineType: UILabel!
    @IBOutlet weak var detailMedicineNm: UILabel!
    @IBOutlet var ShowMedicineDetailView: UIView!
    @IBOutlet weak var imgTry: UIImageView!
    @IBOutlet weak var txtPatientProblems: UITextView!
    
    @IBOutlet weak var txtFollowUpdate: UITextField!
    @IBOutlet weak var collMedicine: UICollectionView!
    @IBOutlet weak var btnAddReport: UIButton!
    @IBOutlet weak var btnAddPaint: UIButton!
    @IBOutlet weak var txtOtherDetail: UITextView!
    @IBOutlet weak var btnSubmitMedicine: UIButton!
    @IBOutlet weak var txtMedicineNm: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPresc: UITextView!
    
    @IBOutlet weak var txtWeight: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHeightInFeet: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnInCemi: DLRadioButton!
    @IBOutlet weak var txtHgtInCemi: SkyFloatingLabelTextField!
    @IBOutlet weak var txtBloodGrp: SkyFloatingLabelTextField!
    @IBOutlet weak var txtTemp: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imgSignFromBack: UIImageView!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDaily: DLRadioButton!
    @IBOutlet weak var btnWeekly: DLRadioButton!
    @IBOutlet weak var btnTimeInterval: DLRadioButton!
    @IBOutlet weak var medicineView: UIView!
    @IBOutlet weak var dailyStackView: UIStackView!
    @IBOutlet weak var otherDetailView: UIView!
    @IBOutlet weak var dayWeekStackView: UIStackView!
    @IBOutlet weak var txtHowManyDays: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHowManyWeeks: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var btnInFeet: DLRadioButton!
    @IBOutlet weak var BasicDetailView: UIView!
    @IBOutlet weak var SignView: UIView!
    @IBOutlet weak var viewDescribePatProblem: UIView!
    @IBOutlet weak var AllTimingView: UIView!
    @IBOutlet weak var btnBeBreak: UIButton!
    @IBOutlet weak var btnAftBrea: UIButton!
    @IBOutlet weak var btnBfLunch: UIButton!
    @IBOutlet weak var btnAftLunch: UIButton!
    @IBOutlet weak var btnBfDinner: UIButton!
    @IBOutlet weak var btnAftDinner: UIButton!
    @IBOutlet weak var checkBfBrk: UIButton!
    @IBOutlet weak var checkAfBrk: UIButton!
    @IBOutlet weak var checkBfLunch: UIButton!
    @IBOutlet weak var checkAfLunch: UIButton!
    @IBOutlet weak var checkBfDinner: UIButton!
    @IBOutlet weak var checkAfDinner: UIButton!
    @IBOutlet weak var writePrescView: UIView!
    @IBOutlet weak var checkboxStackView: UIStackView!
    @IBOutlet weak var HgtcheckboxStackView: NSLayoutConstraint!
    @IBOutlet weak var HgtDailyStackview: NSLayoutConstraint!
    @IBOutlet weak var HgtMedicalView: NSLayoutConstraint!
  
    
    @IBOutlet weak var HgtMedicineCollectionView: NSLayoutConstraint!
    @IBOutlet weak var viewPresDrwingPad: UIView!
    
    @IBOutlet weak var viewpatientDrawing: UIView!
    
    @IBOutlet weak var viewPatientReport: UIView!
    
    var m_nNewLength: Int!
    
   @IBOutlet weak var viewWholeDrawingView: UIView!
    
    var popUp = KLCPopup()
    var signatureFormvc : SignatureVC!
    var AlertWithText = ZAlertView()
    var TxtVal = String()
    var getTxtVal = Bool(false)
    var reportArr = [UIImage]()
    var toast = JYToast()
    var selectedImage: UIImage!
    var DocumentselectedImage: UIImage!
    var filePath: String!
    var fileURL: URL!
    var fileName: String!
    var DocumentImageFileName: String!
    var DocumentFileURL: URL!
    var DocumentFileName: String?
    var m_cPresdata = PresData()
    var PatientdataFromBack = [String : Any]()
    var m_cMedicineData = [MedicineData]()
    var M_CmedicineData = MedicineData()
    var m_cPrescARR = [PresArr]()
    var m_cDrawingARR = [DrawingArr]()
    
    var m_cReportArr = [ReportImageArr]()
    var m_cSIGNARR = [SignatureData]()
    var PatientClinicVisitId = String()
    var MedicineArr = [[String : Any]]()
    var medicineDict = [String : Any]()
    var patient_id = String()
    
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String?
    var loggedinId : Int!
    
    var m_cSignatureData: SignatureData!
    var m_cPrescriptionData : PresArr!
    var m_cReportDataArr    = [SignatureData]()
    var m_cPrescImagesData = [[String : Any]]()
    var m_cReportImagesData = [[String : Any]]()
    var m_cDrawinhImagesData = [[String : Any]]()
    var m_cAllDataArr = [SignatureData]()
    var medicineMinuteTextfield : UITextField!
    
    var m_bBeforBreakfastCheck  = Bool(false)
    var m_bAfterBreakfastCheck  = Bool(false)
    var m_bBeforLunchCheck      = Bool(false)
    var m_bAfterLunchCheck      = Bool(false)
    var m_bBeforDinnerCheck     = Bool(false)
    var m_bAfterDinnerCheck     = Bool(false)
    
    var m_cPressData = CPressData()
    var m_cDrawData = CDrawData()
    var m_cReportData = CReportData()
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnInCemi.tag = 0
        btnInFeet.tag = 1
        btnInFeet.isSelected = true
        btnDaily.isSelected = true
        btnDaily.tag = 1
        
        btnDaily.isMultipleSelectionEnabled = false
        btnInFeet.isMultipleSelectionEnabled = false
        setBtnView()
        self.m_bBeforBreakfastCheck   = false
        self.m_bAfterBreakfastCheck   = false
        self.m_bBeforLunchCheck       = false
        self.m_bAfterLunchCheck       = false
        self.m_bBeforDinnerCheck       = false
        self.m_bAfterDinnerCheck      = false
        
        if self.MedicineArr.isEmpty == true
        {
             self.HgtMedicineCollectionView.constant = 0
        }
        else
        {
            self.HgtMedicineCollectionView.constant = 120
        }
        
        if self.PatientdataFromBack.isEmpty == false
        {
           self.patient_id = self.PatientdataFromBack["patient_id"] as! String
           
        self.PatientClinicVisitId = self.PatientdataFromBack["patient_clinic_visit_id"] as! String
        }
      
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        
        loggedinId = dict["id"] as? Int
        
        collMedicine.delegate = self
        collMedicine.dataSource = self
        createDatePicker()
        
        txtPresc.delegate = self
        txtOtherDetail.delegate = self
        txtPatientProblems.delegate = self
        txtHeightInFeet.delegate = self
        txtWeight.delegate = self
        txtTemp.delegate = self
        txtBloodGrp.delegate = self
        txtHgtInCemi.delegate = self
        txtBloodGrp.clearButtonMode = .whileEditing
        textFeildValid()
        AddJsonData()
    }
   
   
    
    // MARK : ADD JSON FILE
    
    func AddJsonData()
    {
        if let path = Bundle.main.path(forResource: "Type of Conditions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["data"] as? [Any]
                {
                    print(person)
                  //  txtPatientProblems.text = person["name"] as! String
                }
            } catch {
                // handle error
                self.toast.isShow(error as! String)
            }
        }
    }
    
    @IBAction func btnInfeet_onclick(_ sender: Any)
    {
        btnInFeet.tag = 1
        txtHgtInCemi.isHidden = false
        txtHeightInFeet.placeholder = "Feet"
        txtHgtInCemi.text = ""
        txtHeightInFeet.text = ""
    }
    
    @IBAction func btnInCemi_onclick(_ sender: Any)
    {
        btnInCemi.tag = 2
        txtHgtInCemi.isHidden = true
        txtHeightInFeet.placeholder = "Height in Cm"
        txtHgtInCemi.text = ""
        txtHeightInFeet.text = ""
    }
    
    func textFeildValid()
    {
       
        txtHeightInFeet.addTarget(self, action: #selector(HgttextFieldDidChange), for: .editingChanged)
        
        txtWeight.addTarget(self, action: #selector(WgtDidchange), for: .editingChanged)
        
        txtTemp.addTarget(self, action: #selector(TempDidChange), for: .editingChanged)
        
         txtBloodGrp.addTarget(self, action: #selector(bloodGrpDidchange), for: .editingChanged)
        
        txtHowManyDays.addTarget(self, action: #selector(HowManyDaysDidchange), for: .editingChanged)
         txtHowManyWeeks.addTarget(self, action: #selector(HowManyWeeksDidChange), for: .editingChanged)
        
        txtHeightInFeet.addTarget(self, action: #selector(HgtFeetDidChange), for: .editingChanged)
        
     txtHgtInCemi.addTarget(self, action: #selector(HgtCemiDidChange), for: .editingChanged)
        
    }
   
    @objc func HgtCemiDidChange()
    {
        if txtHgtInCemi.text != nil {
            if let floatingLabelTextField = txtHgtInCemi {
                
                
                if txtHgtInCemi.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func HgtFeetDidChange()
    {
        if txtHeightInFeet.text != nil {
            if let floatingLabelTextField = txtHeightInFeet {
                
                
                if txtHeightInFeet.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func HowManyWeeksDidChange()
    {
        if txtHowManyWeeks.text != nil {
            if let floatingLabelTextField = txtHowManyWeeks {
                
                
                if txtHowManyWeeks.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
    @objc func HowManyDaysDidchange()
    {
        if txtHowManyDays.text != nil {
            if let floatingLabelTextField = txtHowManyDays {
                
                
                if txtHowManyDays.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid Days"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func bloodGrpDidchange()
    {
        if txtBloodGrp.text != nil {
            if let floatingLabelTextField = txtBloodGrp {
                
//               if txtBloodGrp.text?.characters.count == 3
//               {
//                if txtBloodGrp.text?.count == 4
//                {
//                    return
//                }
//
//                 txtBloodGrp.text?.append(contentsOf: "/")
//
//                }

                if txtBloodGrp.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid"
                }

                else {

                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        
    }
    
    @objc func TempDidChange()
    {
        
        if txtTemp.text != nil {
            if let floatingLabelTextField = txtTemp {
                
                
                if txtTemp.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid Temperature"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func HgttextFieldDidChange()
    {
        if txtHeightInFeet.text != nil {
            if let floatingLabelTextField = txtHeightInFeet {
                
                
                 if txtHeightInFeet.text?.isValidNumber() == false
                 {
                    floatingLabelTextField.errorMessage = "Invalid Height"
                 }

                else {
                  
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func WgtDidchange()
    {
        if txtWeight.text != nil {
            if let floatingLabelTextField = txtWeight {
                
                
                if txtWeight.text?.isValidNumber() == false
                {
                    floatingLabelTextField.errorMessage = "Invalid Weight"
                }
                    
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView == txtPatientProblems && txtPatientProblems.text == "Write Here.."
        {
            txtPatientProblems.text = ""
        }
        
        if textView == txtPresc && txtPresc.text == "Write Here.."
        {
           txtPresc.text = ""
        }
        
        if textView == txtOtherDetail && txtOtherDetail.text == "Write here.."
        {
            txtOtherDetail.text = ""
        }
        
    }
    
  
    
    func Btn(btn : UIButton)
    {
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
    }
 
    func signImg(imgsign: UIImage, imgName: String)
    {
        let img = imgsign
        imgSignFromBack.image = img
        
        let SignimgName = Date().toMillis()
        let nm = String(describing: SignimgName!)
        let JpegImg = String(self.loggedinId) + nm + ".jpeg"
        print(JpegImg)   //1291234555443.jpeg
        
        self.m_cSignatureData = SignatureData(cSignatureImgName: JpegImg, cSignatureImg: imgsign)
        
        self.m_cSIGNARR.append(self.m_cSignatureData)
        
     }
    
    func reportImages()
    {
        if self.m_cReportData.m_cReportDataArr.count != 0
        {
            self.m_cReportArr = self.m_cReportData.m_cReportDataArr
            var lcdict = [String : Any]()
            
            for lcreport in self.m_cReportArr
            {
                lcdict["dataTag"] = lcreport.Report_Tag
                lcdict["dataName"] = String(self.loggedinId) + lcreport.Report_timestamp + ".jpeg"
                
                self.m_cReportImagesData.append(lcdict)
            }
        }
    }

    func sendDataToFirstPage()  // Drawing images with name and tag name
    {
        if self.m_cPressData.m_cPressDataArr.count != 0
        {
            var lcDict = [String: Any]()
            self.m_cPrescARR = self.m_cPressData.m_cPressDataArr
            
            for lcPresc in self.m_cPressData.m_cPressDataArr
            {
                //let lcimg = lcPresc.PresImg
                //let lcPresTimestamp = lcPresc.PresTimestampNm!
                lcDict["dataName"] = String(self.loggedinId) + lcPresc.PresTimestampNm! + ".jpeg"
                
                
                self.m_cPrescImagesData.append(lcDict)
                
                print(self.m_cPrescImagesData)
                
            }
        }
   
    }

    func DrawingOnPad()
    {
        
        if self.m_cDrawData.m_cDrawDataArr.count != 0
        {
            var lcDict = [String: Any]()
            self.m_cDrawingARR = m_cDrawData.m_cDrawDataArr
            
            for lcDraw in  self.m_cDrawingARR
            {
                let lcPresTimestamp = lcDraw.drawing_timestamp!
                let lcPresImgName = lcDraw.drawing_tag!
                lcDict["dataTag"] = lcPresImgName
                
                lcDict["dataName"] = String(self.loggedinId) + lcPresTimestamp + ".jpeg"
                
                self.m_cDrawinhImagesData.append(lcDict)
                print(self.m_cDrawinhImagesData)
                
            }
        }
    }
    
   override func awakeFromNib() {
        self.signatureFormvc = (AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "SignatureVC") as! SignatureVC)
    }
    
    func setBtnView()
    {
        btnSave.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        btnSave.layer.borderWidth = 1.0
        btnSave.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnSave.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnSave.layer.shadowOpacity = 1.0
        btnSave.layer.shadowRadius = 0.0
        btnSave.layer.masksToBounds = false
        btnSave.layer.cornerRadius = 30.0
        
        medicineView.layer.cornerRadius = 5.0
        otherDetailView.layer.cornerRadius = 5.0
        writePrescView.layer.cornerRadius = 5.0
         SignView.layer.cornerRadius = 5.0
        BasicDetailView.layer.cornerRadius = 5.0

        viewDescribePatProblem.layer.cornerRadius = 5.0
        viewPatientReport.layer.cornerRadius = 5.0
        viewPresDrwingPad.layer.cornerRadius = 5.0
        viewpatientDrawing.layer.cornerRadius = 5.0
        viewWholeDrawingView.layer.cornerRadius = 5.0

       
        medicineView.designCell()
        otherDetailView.designCell()
        writePrescView.designCell()
        SignView.designCell()
        BasicDetailView.designCell()
        viewDescribePatProblem.designCell()
        viewPatientReport.designCell()
        viewPresDrwingPad.designCell()
        viewpatientDrawing.designCell()
        viewWholeDrawingView.designCell()
    }

    func clearMedicineData()
    {
        btnWeekly.tag = 0
        btnDaily.tag = 0
        btnTimeInterval.tag = 0
        txtMedicineNm.text = ""
        txtHowManyDays.text = ""
        txtHowManyWeeks.text = ""
        btnDaily.isSelected = false
        btnWeekly.isSelected = false
        btnTimeInterval.isSelected = false
        
        btnBeBreak.setTitle("Before Breakfast", for: .normal)
        self.checkBfBrk.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
        self.btnAftBrea.setTitle("After Breakfast", for: .normal)
        self.checkAfBrk.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
        btnBfLunch.setTitle("Before Lunch", for: .normal)
        self.checkBfLunch.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
        self.btnAftLunch.setTitle("After Lunch", for: .normal)
        self.checkAfLunch.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
        self.btnBfDinner.setTitle("Before Dinner", for: .normal)
        self.checkBfDinner.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
        self.btnAftDinner.setTitle("After Dinner", for: .normal)
        self.checkAfDinner.setImage(UIImage(named: "emptyCheck"), for: .normal)
        
    }
    
    func validMedicine() -> Bool
    {
        if txtMedicineNm.text == ""
        {
            ZAlertView.init(title: "Medoc", msg: "Please enter medicine name", actiontitle: "OK") {
                print("")
                
            }
            return false
        }
        
        if (btnDaily.tag == 0) && (btnWeekly.tag == 0) && (btnTimeInterval.tag == 0)
        {
            
            ZAlertView.init(title: "Medoc", msg: "Please select one of the Daily, Weekly or Time interval", actiontitle: "OK") {
                print("")
            }

            return false
        }
        
        
        if btnDaily.tag != 0 || btnWeekly.tag != 0
        {
            if m_bBeforBreakfastCheck == false && m_bAfterBreakfastCheck == false && m_bBeforLunchCheck == false && m_bAfterLunchCheck == false && m_bBeforDinnerCheck == false && m_bAfterDinnerCheck == false
            {
                ZAlertView.init(title: "Medoc", msg: "Please enter medicine timing", actiontitle: "OK") {
                    print("")
                }
                
                return false
            }
            
        }
        
        
        if btnDaily.isSelected == true
        {
           if txtHowManyDays.text == ""
           {
            
            ZAlertView.init(title: "Medoc", msg: "Please mention how many days patient take medicine", actiontitle: "OK") {
                print("")
            }
            return false
            }
        }
        
        if btnWeekly.isSelected == true
        {
            if txtHowManyDays.text == ""
            {
                
                ZAlertView.init(title: "Medoc", msg: "Please mention how many days patient take medicine", actiontitle: "OK") {
                    print("")
                }
                return false
            }
            if txtHowManyWeeks.text == ""
            {
                ZAlertView.init(title: "Medoc", msg: "Please mention how many week patient take medicine", actiontitle: "OK") {
                    print("")
                }
                return false
            }
        }
        
        if btnTimeInterval.isSelected == true
        {
            if txtHowManyDays.text == ""
            {
                ZAlertView.init(title: "Medoc", msg: "Please mention how many days patient take medicine", actiontitle: "OK") {
                    print("")
                }
                return false
            }
            
            if txtHowManyWeeks.text == ""
            {
                ZAlertView.init(title: "Medoc", msg: "Please mention how many time patient take medicine", actiontitle: "OK") {
                    print("")
                }
      
                return false
            }
            
        }
        
        return true
    }
    
    func setMedicineDict()
    {
        
    }
    
    
    @IBAction func btnSubmitMedicine_onclick(_ sender: Any)
    {
        if validMedicine()
        {
            
            self.view.endEditing(true)
            
            M_CmedicineData.medicineName = self.txtMedicineNm.text!
            M_CmedicineData.intervalPeriod = self.txtHowManyDays.text!
            M_CmedicineData.intervalTime = self.txtHowManyWeeks.text!
            
            
            medicineDict["patientId"] = self.patient_id
            medicineDict["medicineName"] = M_CmedicineData.medicineName
            medicineDict["intervalType"] = M_CmedicineData.intervalType
            medicineDict["intervalPeriod"] = M_CmedicineData.intervalPeriod
            medicineDict["intervalTime"] = M_CmedicineData.intervalTime
            medicineDict["beforeBreakfast"] = M_CmedicineData.beforeBreakfast
            medicineDict["beforeBreakfastTime"] = M_CmedicineData.beforeBreakfastTime
            medicineDict["afterBreakfast"] = M_CmedicineData.afterBreakfast
            medicineDict["afterBreakfastTime"] = M_CmedicineData.afterBreakfastTime
            medicineDict["beforeLunch"] = M_CmedicineData.beforeLunch
            medicineDict["beforeLunchTime"] = M_CmedicineData.beforeLunchTime
            medicineDict["afterLunch"] = M_CmedicineData.afterLunch
            medicineDict["afterLunchTime"] = M_CmedicineData.afterLunchTime
            medicineDict["beforeDinner"] = M_CmedicineData.beforeDinner
            medicineDict["beforeDinnerTime"] = M_CmedicineData.beforeDinnerTime
            medicineDict["afterDinner"] = M_CmedicineData.afterLunch
            medicineDict["afterDinnerTime"] = M_CmedicineData.afterDinnerTime
            self.MedicineArr.append(medicineDict)
            print(self.MedicineArr)
            
            self.HgtMedicineCollectionView.constant = 120
            
            self.collMedicine.reloadData()
            clearMedicineData()
        }
        
    }
    
    
    @IBAction func detailBtnOK_onClick(_ sender: Any)
    {
        popUp.dismiss(true)
    }
    
    
    @IBAction func btnDaily_onClick(_ sender: Any)
    {
        AllTimingView.isHidden = false

        self.view.endEditing(true)
        self.btnDaily.tag = 1
        
        self.txtHowManyWeeks.isHidden = true
        self.HgtMedicalView.constant = 550
        self.dailyStackView.isHidden = false
        self.checkboxStackView.isHidden = false
        
        M_CmedicineData.intervalType = 1
        M_CmedicineData.intervalTime = "NF"
    }
    
    @IBAction func btnWeekly_onClick(_ sender: Any)
    {
        AllTimingView.isHidden = false

        self.view.endEditing(true)
        self.btnWeekly.tag = 2
        self.txtHowManyWeeks.placeholder = "For how many week?"
        self.txtHowManyWeeks.isHidden = false
        self.dailyStackView.isHidden = false
        self.checkboxStackView.isHidden = false
        self.HgtMedicalView.constant = 550
        M_CmedicineData.intervalType = 2
    }
    
    
    @IBAction func btnTimeInterval_onClick(_ sender: Any)
    {
        AllTimingView.isHidden = true
        self.view.endEditing(true)
        self.btnTimeInterval.tag = 3
        self.txtHowManyWeeks.placeholder = "For how many hours?"
        self.dailyStackView.isHidden = true
        self.checkboxStackView.isHidden = true
        self.HgtMedicalView.constant = 410
        M_CmedicineData.intervalType = 3
        
        M_CmedicineData.beforeBreakfast = "0"
        M_CmedicineData.beforeBreakfastTime = "0"
        M_CmedicineData.afterBreakfast = "0"
        M_CmedicineData.afterBreakfastTime = "0"
        M_CmedicineData.beforeLunch = "0"
        M_CmedicineData.beforeLunchTime = "0"
        M_CmedicineData.afterLunch = "0"
        M_CmedicineData.afterLunchTime = "0"
        M_CmedicineData.beforeDinner = "0"
        M_CmedicineData.beforeDinnerTime = "0"
        
    }
    
    func ShowAlerView(sender: UIButton, cTextMsg: String, cTimeVal: String, cCheckMark: UIButton)
    {
        
        UIView.animate(withDuration: 1.0) {
            
            ZAlertView.showAnimation = .fadeIn
            
            self.AlertWithText = ZAlertView(title: "Medoc", message: "Enter the period, patient should take medicine \(cTextMsg)", isOkButtonLeft: false, okButtonText: "OK", cancelButtonText: "Cancel", okButtonHandler: { (send) in
                
                self.medicineMinuteTextfield = self.AlertWithText.getTextFieldWithIdentifier("Remark")!
                
                self.medicineMinuteTextfield.delegate = self
              
//                self.medicineMinuteTextfield = SkyFloatingLabelTextField()
                
                self.TxtVal = self.medicineMinuteTextfield.text!
                
                if self.TxtVal.count > 2 && self.TxtVal.isValidNumber() == false
                {
                    ZAlertView.init(title: "Medoc", msg: "Please enter medicine time in minutes (max. 2 digits)", actiontitle: "OK") {
                        print("")
                        
                    }
                }
                    
                else if self.TxtVal.count > 2 || self.TxtVal.isValidNumber() == false
                {
                    ZAlertView.init(title: "Medoc", msg: "Please enter medicine time in minutes (max. 2 digits)", actiontitle: "OK") {
                        print("")
                        
                    }
                }

                else
                {
                    if self.TxtVal != ""
                    {
                        
                        let text = self.TxtVal + " " + cTextMsg
                        sender.setTitle(text, for: .normal)
                        cCheckMark.setImage(UIImage(named: "fillCheck"), for: .normal)
                        
                        if sender == self.btnBeBreak
                        {
                            self.M_CmedicineData.beforeBreakfast = cTimeVal
                            self.M_CmedicineData.beforeBreakfastTime = self.TxtVal
                        }
                        else if sender == self.btnAftBrea
                        {
                            self.M_CmedicineData.afterBreakfast = cTimeVal
                            self.M_CmedicineData.afterBreakfastTime = self.TxtVal
                        }
                        else if sender == self.btnBfLunch
                        {
                            self.M_CmedicineData.beforeLunch = cTimeVal
                            self.M_CmedicineData.beforeLunchTime = self.TxtVal
                        }
                        else if sender == self.btnAftLunch
                        {
                            self.M_CmedicineData.afterLunch = cTimeVal
                            self.M_CmedicineData.afterLunchTime = self.TxtVal
                        }
                        else if sender == self.btnBfDinner
                        {
                            self.M_CmedicineData.beforeDinner = cTimeVal
                            self.M_CmedicineData.beforeDinnerTime = self.TxtVal
                        }
                        else
                        {
                            self.M_CmedicineData.afterDinner = cTimeVal
                            self.M_CmedicineData.afterDinnerTime = self.TxtVal
                        }
                    }
                }
                
                
                
                
                send.dismissWithDuration(0.5)
                ZAlertView.hideAnimation = .fadeOut
                
            }) { (cancel) in
                cancel.dismissWithDuration(0.5)
            }
            self.AlertWithText.addTextField("Remark", placeHolder: "Enter the time period in minutes")
            self.AlertWithText.showWithDuration(1.0)
            
        }
    }
    
    
    func HideAlertView(sender: UIButton, cTextMsg: String,cTimeVal: String, cCheckMark: UIButton)
    {
        sender.setTitle(cTextMsg, for: .normal)
        cCheckMark.setImage(UIImage(named: "emptyCheck"), for: .normal)
    
//        self.M_CmedicineData.beforeBreakfast        = cTimeVal
//        self.M_CmedicineData.beforeBreakfastTime    = cTimeVal
//
        if sender == self.btnBeBreak
        {
            self.M_CmedicineData.beforeBreakfast = cTimeVal
            self.M_CmedicineData.beforeBreakfastTime = cTimeVal
        }
        else if sender == self.btnAftBrea
        {
            self.M_CmedicineData.afterBreakfast = cTimeVal
            self.M_CmedicineData.afterBreakfastTime = cTimeVal
        }
        else if sender == self.btnBfLunch
        {
            self.M_CmedicineData.beforeLunch = cTimeVal
            self.M_CmedicineData.beforeLunchTime = cTimeVal
        }
        else if sender == self.btnAftLunch
        {
            self.M_CmedicineData.afterLunch = cTimeVal
            self.M_CmedicineData.afterLunchTime = cTimeVal
        }
        else if sender == self.btnBfDinner
        {
            self.M_CmedicineData.beforeDinner = cTimeVal
            self.M_CmedicineData.beforeDinnerTime = cTimeVal
        }
        else
        {
            self.M_CmedicineData.afterDinner = cTimeVal
            self.M_CmedicineData.afterDinnerTime = cTimeVal
        }
        
    }
    
    @IBAction func btnBeforeBreakfast_onclick(_ sender: Any)
    {
        
        self.m_bBeforBreakfastCheck = !self.m_bBeforBreakfastCheck
        
        if self.m_bBeforBreakfastCheck    // if true
        {
            self.ShowAlerView(sender: self.btnBeBreak,cTextMsg: "Minutes Before Breakfast", cTimeVal: "1",cCheckMark: checkBfBrk)
        }else{
            
            self.HideAlertView(sender: btnBeBreak, cTextMsg: "Before Breakfast", cTimeVal: "0",cCheckMark: checkBfBrk)
        }
        
        
        if false == m_bAfterBreakfastCheck
        {
            self.M_CmedicineData.afterBreakfast         = "0"
            self.M_CmedicineData.afterBreakfastTime     = "0"
        }
        
        if false == m_bBeforLunchCheck
        {
            self.M_CmedicineData.beforeLunch        = "0"
            self.M_CmedicineData.beforeLunchTime    = "0"
        }
        
        if false == m_bAfterLunchCheck
        {
            self.M_CmedicineData.afterLunch         = "0"
            self.M_CmedicineData.afterLunchTime     = "0"
        }
        
        if false == m_bBeforDinnerCheck
        {
            self.M_CmedicineData.beforeDinner       = "0"
            self.M_CmedicineData.beforeDinnerTime   = "0"
        }
        
        if false == m_bAfterDinnerCheck
        {
            self.M_CmedicineData.afterDinner        = "0"
            self.M_CmedicineData.afterDinnerTime    = "0"
        }
    
    }
    
    @IBAction func btnAfterBreakfast_onclick(_ sender: Any)
    {
        self.m_bAfterBreakfastCheck = !self.m_bAfterBreakfastCheck
        
        if self.m_bAfterBreakfastCheck
        {
            self.ShowAlerView(sender: self.btnAftBrea,cTextMsg: "Minutes After Breakfast", cTimeVal: "1", cCheckMark: checkAfBrk)
        }else{
            self.HideAlertView(sender: btnAftBrea, cTextMsg: "After Breakfast", cTimeVal: "0", cCheckMark: checkAfBrk)
        }
        
        
        if false == m_bBeforBreakfastCheck
        {
            self.M_CmedicineData.beforeBreakfast         = "0"
            self.M_CmedicineData.beforeBreakfastTime     = "0"
        }
        
        if false == m_bBeforLunchCheck
        {
            self.M_CmedicineData.beforeLunch        = "0"
            self.M_CmedicineData.beforeLunchTime    = "0"
        }
        
        if false == m_bAfterLunchCheck
        {
            self.M_CmedicineData.afterLunch         = "0"
            self.M_CmedicineData.afterLunchTime     = "0"
        }
        
        if false == m_bBeforDinnerCheck
        {
            self.M_CmedicineData.beforeDinner       = "0"
            self.M_CmedicineData.beforeDinnerTime   = "0"
        }
        
        if false == m_bAfterDinnerCheck
        {
            self.M_CmedicineData.afterDinner        = "0"
            self.M_CmedicineData.afterDinnerTime    = "0"
        }

    }
    
    @IBAction func btnBeforeLunch_onclick(_ sender: Any)
    {

        self.m_bBeforLunchCheck = !self.m_bBeforLunchCheck
        
        if self.m_bBeforLunchCheck
        {
            self.ShowAlerView(sender: self.btnBfLunch,cTextMsg: "Minutes Before Lunch", cTimeVal: "1", cCheckMark: checkBfLunch)
        }else{
            self.HideAlertView(sender: btnBfLunch, cTextMsg: "Before Lunch", cTimeVal: "0", cCheckMark: checkBfLunch)
        }
        
        
        if false == m_bBeforBreakfastCheck
        {
            self.M_CmedicineData.beforeBreakfast         = "0"
            self.M_CmedicineData.beforeBreakfastTime     = "0"
        }
        
        if false == m_bAfterBreakfastCheck
        {
            self.M_CmedicineData.afterBreakfast        = "0"
            self.M_CmedicineData.afterBreakfastTime    = "0"
        }
        
        if false == m_bAfterLunchCheck
        {
            self.M_CmedicineData.afterLunch         = "0"
            self.M_CmedicineData.afterLunchTime     = "0"
        }
        
        if false == m_bBeforDinnerCheck
        {
            self.M_CmedicineData.beforeDinner       = "0"
            self.M_CmedicineData.beforeDinnerTime   = "0"
        }
        
        if false == m_bAfterDinnerCheck
        {
            self.M_CmedicineData.afterDinner        = "0"
            self.M_CmedicineData.afterDinnerTime    = "0"
        }
    
    }
    
    @IBAction func btnAfterLunch_onclick(_ sender: Any)
    {
        self.m_bAfterLunchCheck = !self.m_bAfterLunchCheck
        
        if self.m_bAfterLunchCheck
        {
            self.ShowAlerView(sender: self.btnAftLunch,cTextMsg: "Minutes After Lunch", cTimeVal: "1", cCheckMark: checkAfLunch)
        }else{
            self.HideAlertView(sender: btnAftLunch, cTextMsg: "After Lunch", cTimeVal: "0", cCheckMark: checkAfLunch)
        }
        
        
        if false == m_bBeforBreakfastCheck
        {
            self.M_CmedicineData.beforeBreakfast         = "0"
            self.M_CmedicineData.beforeBreakfastTime     = "0"
        }
        
        if false == m_bAfterBreakfastCheck
        {
            self.M_CmedicineData.afterBreakfast        = "0"
            self.M_CmedicineData.afterBreakfastTime    = "0"
        }
        
        if false == m_bBeforLunchCheck
        {
            self.M_CmedicineData.beforeLunch         = "0"
            self.M_CmedicineData.beforeLunchTime     = "0"
        }
        
        if false == m_bBeforDinnerCheck
        {
            self.M_CmedicineData.beforeDinner       = "0"
            self.M_CmedicineData.beforeDinnerTime   = "0"
        }
        
        if false == m_bAfterDinnerCheck
        {
            self.M_CmedicineData.afterDinner        = "0"
            self.M_CmedicineData.afterDinnerTime    = "0"
        }
        
   
    }
    
    @IBAction func btnBeforeDinner_onClick(_ sender: Any)
    {
        self.m_bBeforDinnerCheck = !self.m_bBeforDinnerCheck
        
        if self.m_bBeforDinnerCheck
        {
            self.ShowAlerView(sender: self.btnBfDinner,cTextMsg: "Minutes Before Dinner", cTimeVal: "1", cCheckMark: checkBfDinner)
        }else{
            self.HideAlertView(sender: btnBfDinner, cTextMsg: "Before Dinner", cTimeVal: "0", cCheckMark: checkBfDinner)
        }
        
        
        if false == m_bBeforBreakfastCheck
        {
            self.M_CmedicineData.beforeBreakfast         = "0"
            self.M_CmedicineData.beforeBreakfastTime     = "0"
        }
        
        if false == m_bAfterBreakfastCheck
        {
            self.M_CmedicineData.afterBreakfast        = "0"
            self.M_CmedicineData.afterBreakfastTime    = "0"
        }
        
        if false == m_bAfterLunchCheck
        {
            self.M_CmedicineData.afterLunch         = "0"
            self.M_CmedicineData.afterLunchTime     = "0"
        }
        
        if false == m_bBeforLunchCheck
        {
            self.M_CmedicineData.beforeLunch       = "0"
            self.M_CmedicineData.beforeLunchTime   = "0"
        }
        
        if false == m_bAfterDinnerCheck
        {
            self.M_CmedicineData.afterDinner        = "0"
            self.M_CmedicineData.afterDinnerTime    = "0"
        }
        
      
    }
    
    @IBAction func btnAfterDinner_onClick(_ sender: Any)
    {
        self.m_bAfterDinnerCheck = !self.m_bAfterDinnerCheck
        
        if self.m_bAfterDinnerCheck
        {
            self.ShowAlerView(sender: self.btnAftDinner,cTextMsg: "Minutes After Dinner", cTimeVal: "1", cCheckMark: checkAfDinner)
        }else{
            self.HideAlertView(sender: btnAftDinner, cTextMsg: "After Dinner", cTimeVal: "0", cCheckMark: checkAfDinner)
        }
        
        
        if false == m_bBeforBreakfastCheck
        {
            self.M_CmedicineData.beforeBreakfast         = "0"
            self.M_CmedicineData.beforeBreakfastTime     = "0"
        }
        
        if false == m_bAfterBreakfastCheck
        {
            self.M_CmedicineData.afterBreakfast        = "0"
            self.M_CmedicineData.afterBreakfastTime    = "0"
        }
        
        if false == m_bAfterLunchCheck
        {
            self.M_CmedicineData.afterLunch         = "0"
            self.M_CmedicineData.afterLunchTime     = "0"
        }
        
        if false == m_bBeforLunchCheck
        {
            self.M_CmedicineData.beforeLunch       = "0"
            self.M_CmedicineData.beforeLunchTime   = "0"
        }
        
        if false == m_bBeforDinnerCheck
        {
            self.M_CmedicineData.beforeDinner        = "0"
            self.M_CmedicineData.beforeDinnerTime    = "0"
        }
        
       
    }
    
    @IBAction func btnCloseform_onclick(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSavePresc_onClick(_ sender: Any)
    {
        // Call Api from server
        
        
        if btnInFeet.tag == 1
        {
            if txtHgtInCemi.text != "" && txtHeightInFeet.text != ""
            {
                let feetVal = txtHeightInFeet.text!
                let InchVal = txtHgtInCemi.text!
                m_cPresdata.height = "\(feetVal) Feet \(InchVal) Inch"
                print(m_cPresdata.height!)
                
            }else
            {
                m_cPresdata.height = "NF"
            }
          //  return false
            
        }
        
        
        if btnInCemi.tag == 2
        {
            if txtHeightInFeet.text != ""
            {
                let valText = Float(txtHeightInFeet.text!)
                
                let INCH_IN_CM: Float = 2.54
                
                let numInches = Int(roundf(valText! / INCH_IN_CM))
                let feet: Int = numInches / 12
                let inches: Int = numInches % 12
                
                m_cPresdata.height = "\(feet) Feet \(inches) Inch"
                
            }else{
                m_cPresdata.height = "NF"
            }
          //  return false
        }
        
        
        
        
        if validPresData()
        {
            ZAlertView(title: "Medoc", msg: "Are you sure you want to send this prescription?", dismisstitle: "No", actiontitle: "Yes")
            {
                SwiftLoader.show(animated: true)
                self.sendPres()
            }
            
          
        }
    }
    
    func validPresData() -> Bool
    {
        
        
        if txtBloodGrp.text != ""
        {
            if txtBloodGrp.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Blood Pressure", actiontitle: "Ok")
                {
                    print("")
                }
                return false
            }
            
        }
        if txtWeight.text != ""
        {
            if txtWeight.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Weight", actiontitle: "Ok")
                {
                    print("")
                }
                 return false
            }
           
        }
        
        if txtTemp.text != ""
        {
            if txtTemp.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Temperature", actiontitle: "Ok")
                {
                    print("")
                }
                 return false
            }
           
        }
        
        
        if txtHeightInFeet.text != ""
        {
            if txtTemp.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Height", actiontitle: "Ok")
                {
                    print("")
                }
                   return false
            }
         
        }
        
        if txtHgtInCemi.text != ""
        {
            if txtHgtInCemi.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Height", actiontitle: "Ok")
                {
                    print("")
                }
                  return false
            }
          
        }
        
        if txtHowManyDays.text != ""
        {
            if txtHowManyDays.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Days", actiontitle: "Ok")
                {
                    print("")
                }
                 return false
            }
           
        }
        
        if txtHowManyWeeks.text != ""
        {
            if txtHowManyWeeks.errorMessage != ""
            {
                ZAlertView.init(title: "Medoc", msg: "Invalid Weeks", actiontitle: "Ok")
                {
                    print("")
                }
                  return false
            }
          
        }
        
        
        if txtPatientProblems.text == "Write Here.."
        {
            ZAlertView.init(title: "Medoc", msg: "Please Enter Patient Problem", actiontitle: "Ok")
            {
                print("")
            }
            return false
        }
        
        if txtPresc.text == "Write Here.." && m_cPrescARR.isEmpty
        {
            ZAlertView.init(title: "Medoc", msg: "Please Enter Prescription or draw prescription", actiontitle: "Ok")
            {
                print("")
            }
            return false
        }
        
        if self.m_cSIGNARR.isEmpty == true
        {
            ZAlertView.init(title: "Medoc", msg: "Please submit signature", actiontitle: "Ok")
            {
                print("")
            }
            return false
        }

        return true
    }
    
    func sendPres()
    {
       SwiftLoader.show(animated: true)
        
        if btnInFeet.tag == 0
        {
            m_cPresdata.height = "NF"
        }
        
        if btnInCemi.tag == 0
        {
            m_cPresdata.height = "NF"
            
        }
        
        
        if txtTemp.text == ""
        {
            txtTemp.text = "NF"
           
        }
        if txtBloodGrp.text == ""
        {
            txtBloodGrp.text = "NF"
        }
        
        if txtWeight.text == ""
        {
            txtWeight.text = "NF"
        }
        if txtOtherDetail.text == ""
        {
            txtOtherDetail.text = "NF"
        }
       
      
        if m_cPressData.m_cPressDataArr.count != 0
        {
            m_cPresdata.handwritten_image = json(from: m_cPrescImagesData)
            
        }else{
            m_cPresdata.handwritten_image = "NF"
            
        }
        
        if m_cDrawData.m_cDrawDataArr.count != 0
        {
            m_cPresdata.drawing_image = json(from: m_cDrawinhImagesData)
        }else
        {
            m_cPresdata.drawing_image = "NF"
        }
        
        if m_cReportData.m_cReportDataArr.count != 0
        {
            m_cPresdata.image_name = json(from: m_cReportImagesData)
        }else
        {
             m_cPresdata.image_name = "NF"
        }
        
        if MedicineArr != nil
        {
            m_cPresdata.medicine_data = json(from: MedicineArr)
        }else{
            m_cPresdata.medicine_data = "NF"
        }
        
        if self.m_cSIGNARR.isEmpty == false
        {
             m_cPresdata.signature_image = m_cSignatureData.SignatureImgName
        }else
        {
            m_cPresdata.signature_image = "NF"
        }
        
        
        
        let PresApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/add_prescription"
        
        let param = ["patient_id" : patient_id,
                     "temperature" : txtTemp.text!,
                     "weight" : txtWeight.text!,
                     "height" : m_cPresdata.height!,
                     "blood_pressure" : txtBloodGrp.text!,
                     "other_details" : txtOtherDetail.text!,
                     "refered_by" : "Rupali",
                     "prescription_details" : txtPresc.text!,
                     "loggedin_id" : self.loggedinId!,
                     "patient_problem" : txtPatientProblems.text!,
                     "signature_image" : m_cPresdata.signature_image!,  //cmplsry
                     "handwritten_image" : m_cPresdata.handwritten_image!,
                     "drawing_image" : m_cPresdata.drawing_image!,
                     "medicine_data" : m_cPresdata.medicine_data!,      // MedicineArr,
                     "patient_clinic_visit_id" : PatientClinicVisitId,
                     "followup_date" : txtFollowUpdate.text!,
                     "image_name" : m_cPresdata.image_name!
            ] as [String : Any]
        
        print(param)

        
        Alamofire.request(PresApi, method: .post, parameters: param, encoding : JSONEncoding.default, headers : nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.toast.isShow("Prescription added")
                    self.AddFiles()
                    
                    let PrescId = json["prescription_id"] as! Int
                
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    
    
    func AddFiles()
    {
        let FileApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/add_files"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
     
                if self.m_cSIGNARR.isEmpty == false
                {
                  
                    let lcSignData = SignatureData(cSignatureImgName: self.m_cSignatureData.map { $0.SignatureImgName}!, cSignatureImg: self.m_cSignatureData.map { $0.SignatureImg!}!)
                    
                    self.m_cAllDataArr.append(lcSignData)
                    
                }
                
       
                for lcimg in self.m_cPrescARR
                {
                  
                    let imgNm = String(self.loggedinId) + lcimg.PresTimestampNm! + ".jpeg"
                    
                    let lcImgData = SignatureData(cSignatureImgName: imgNm, cSignatureImg: lcimg.PresImg)
                    self.m_cAllDataArr.append(lcImgData)
                }
                
                for lcimg in self.m_cReportArr
                {
                    
                    let Reprt_img_nm = String(self.loggedinId) + lcimg.Report_timestamp + ".jpeg"
                    
                    let lcImgData = SignatureData(cSignatureImgName: Reprt_img_nm, cSignatureImg: lcimg.Report_img)
                    self.m_cAllDataArr.append(lcImgData)
                }
        
                for lcimg in self.m_cDrawingARR
                {
                    let draw_img_nm = String(self.loggedinId) + lcimg.drawing_timestamp + ".jpeg"
                    
                    let lcImgData = SignatureData(cSignatureImgName: draw_img_nm, cSignatureImg: lcimg.drawing_img)
                    self.m_cAllDataArr.append(lcImgData)
                }
                
                
         for ImgData in self.m_cAllDataArr
         {
            print(self.m_cAllDataArr.count)
            print(ImgData)
            let img = ImgData.SignatureImg
            let Timestamp = ImgData.SignatureImgName
            
            let data = img!.jpegData(compressionQuality: 0.0)
            
            multipartFormData.append(data!, withName: "images[]", fileName: Timestamp, mimeType: "images/jpeg")
        }
            
        },
            
            usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
            to : FileApi,
            method: .post)
        
        { (result) in
            
            print(result)
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value as? [String: Any] {
                        print("Response : ",JSON)
                         SwiftLoader.hide()
                        
                        let Msg = JSON["msg"] as! String
                        if Msg == "success"
                        {
                           
                            
                            ZAlertView.init(title: "Medoc", msg: "Prescription Added successfully", actiontitle: "OK") {
                                print("")
                                
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            //self.dismiss(animated: true, completion: nil)
                            
                        }else if Msg == "fail"
                        {
                            self.toast.isShow("Images not uploaded")
                        }
                        else
                        {
                           self.toast.isShow("No any image for upload")
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }

    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    @IBAction func btnAddReport_onclick(_ sender: Any)
    {
        if self.m_cReportData.m_cReportDataArr.isEmpty
        {
         self.TakePhoto()
        }else{
            let reportvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddReportVC") as! AddReportVC
         reportvc.m_cReportData = self.m_cReportData
            reportvc.m_cReportDelegate = self
            self.navigationController?.pushViewController(reportvc, animated: true)
        }
        
    }
    
    func TakePhoto()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            for lcAttachment in CDBAttachmentArr
            {
                self.fileName = lcAttachment.fileName
                //print(self.fileName)
              //  print(self.filePath)
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
                    let timestamp = Date().toMillis()
                    image?.accessibilityIdentifier = String(describing: timestamp)
                    
//                    self.m_cReportArr.Report_img = image!
//                    self.m_cReportArr.Report_timestamp = String(describing: timestamp)
             
              let lcReportVC = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddReportVC") as! AddReportVC
                
                    let lcReport = ReportImageArr(cReport_img: image!, cReport_timestmp: String(describing: timestamp), cReport_tag: self.fileName)
                    
                    self.m_cReportData.m_cReportDataArr.append(lcReport)
                    
                 lcReportVC.m_cReportData = self.m_cReportData
                    lcReportVC.m_cReportDelegate = self
              self.navigationController?.pushViewController(lcReportVC, animated: true)
                    
                   
                    
                   // self.m_cReportImgArr.append(lcDict)
                    
                    //self.tblReportData.reloadData()
                    //self.selectedImage = image
                })
                
            }
            
        }, cancel: nil)
        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.capturedVideoQulity = UIImagePickerController.QualityType.typeHigh
        attachmentPickerController.allowsMultipleSelection = false
        attachmentPickerController.allowsSelectionFromOtherApps = false
        attachmentPickerController.present(on: self)
    }
    
    
    func DrawingDocs(docImg: UIImage, doctag: String, doctimeStamp: String) {
        print("")
    }
    
    func PaintDocs(docs: UIImage, docnm: String, docTimeStamp: String) {
      /*  let prescvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddPrescriptionDrawingVC") as! AddPrescriptionDrawingVC
        
        if self.m_cPrescARR.isEmpty == false
        {
            prescvc.m_cPrescArr = self.m_cPrescARR
        }
        
        prescvc.m_cDrawimg = self
        self.present(prescvc, animated: true, completion: nil)*/
    }
    
    func ShowAddPrescriptionVC(bFrom: Bool)
    {
        let Presvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        Presvc.m_bView = bFrom
        Presvc.m_cPaintDocsdelegate = self
        
        if bFrom
        {
            Presvc.m_cDrawData = self.m_cDrawData
        }else{
            Presvc.m_cPressData = self.m_cPressData
        }
       self.navigationController?.pushViewController(Presvc, animated: true)
    }
    
    @IBAction func btnAddPresc_onClick(_ sender: Any)
    {
        if self.m_cPressData.m_cPressDataArr.isEmpty == true
        {
          self.ShowAddPrescriptionVC(bFrom: false)
        }
        else
        {
          let lcAddPrescriptionDrawingVC = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddPrescriptionDrawingVC") as! AddPrescriptionDrawingVC
           
            lcAddPrescriptionDrawingVC.m_cDrawimg = self
            lcAddPrescriptionDrawingVC.m_cPressData = self.m_cPressData
             self.navigationController?.pushViewController(lcAddPrescriptionDrawingVC, animated: true)
            
       }
        
        
    }
    
    @IBAction func btnAddDrawing_onClick(_ sender: Any)
    {
        if m_cDrawData.m_cDrawDataArr.isEmpty
        {
            self.ShowAddPrescriptionVC(bFrom: true)
        }else{
            let lcDrawingVC = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddDrawingVC") as! AddDrawingVC
            lcDrawingVC.m_cDrawData = self.m_cDrawData
            self.navigationController?.pushViewController(lcDrawingVC, animated: true)
        }
        
    }
    
    @IBAction func btnSignature_onClick(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5)
        {
            self.signatureFormvc.view.frame = self.view.frame
            self.signatureFormvc.m_cSignDelegate = self
            self.view.addSubview(self.signatureFormvc.view)
            self.signatureFormvc.view.clipsToBounds = true
        }
    }
   
  // MARK : DATEPICKER
    
    func StringFromDate(nDate: Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: nDate)
    }
    
    func createDatePicker()
    {
        _ = Date()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelPicker))
        
        toolBar.setItems([barBtnItem, barBtnCancel], animated: false)
        
        txtFollowUpdate.inputAccessoryView = toolBar
        txtFollowUpdate.inputView = datepicker
        
    }
    
    @objc func donePresses()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let txt = "Follow update"
        txtFollowUpdate.text = txt + "  " + dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
        self.view.endEditing(true)
    }
    
    @objc func CancelPicker()
    {
        self.view.endEditing(true)
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    @objc func DeleteMedicine_Click(sender: AnyObject)
    {
        
        ZAlertView(title: "Medoc", msg: "Are you sure you want to delete this ?", dismisstitle: "No", actiontitle: "Yes")
        {
            let nIndex = sender.tag
            let refArrObj = self.MedicineArr[nIndex!]
            self.MedicineArr.remove(at: nIndex!)
            self.collMedicine.reloadData()
        }
        
    }
    
    func setMedicineTiming()
    {
        
    }
    
}

extension AndriodPrescFormVC : ImageScannerControllerDelegate
{
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
}
extension UIImageView
{
    func getFileName() -> String? {
        // First set accessibilityIdentifier of image before calling.
        let imgName = self.image?.accessibilityIdentifier
        return imgName
    }
}
extension AndriodPrescFormVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

        if MedicineArr != nil
        {
            return MedicineArr.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collMedicine.dequeueReusableCell(withReuseIdentifier: "ShowMedicineCell", for: indexPath) as! ShowMedicineCell
        
        if MedicineArr.isEmpty == false
        {
            let lcdict = MedicineArr[indexPath.row]
            
            cell.lblMedicineNm.text = lcdict["medicineName"] as! String
            cell.backview.designCell()
            
            cell.btndelete.tag = indexPath.row
            cell.btndelete.addTarget(self, action: #selector(DeleteMedicine_Click(sender:)), for: .touchUpInside)
            
            var FirstTimeMedicine = String()
            var SecondTimemedicine = String()
            var ThirdTimeMedicine = String()
            
            let beforeBrkfast = lcdict["beforeBreakfast"] as! String
            let aftBrkfast = lcdict["afterBreakfast"] as! String
            
            if beforeBrkfast == "1" || aftBrkfast == "1"
            {
                FirstTimeMedicine = "1-"
            }else
            {
                FirstTimeMedicine = "0-"
            }
            
            let beforeLunchfast = lcdict["beforeLunch"] as! String
            let aftLunchfast = lcdict["afterLunch"] as! String
            
            if beforeLunchfast == "1" || aftLunchfast == "1"
            {
                SecondTimemedicine = "1-"
            }else
            {
                SecondTimemedicine = "0-"
            }
            
            let beforeDinnerfast = lcdict["beforeDinner"] as! String
            let aftDinnerfast = lcdict["afterDinner"] as! String
            
            if beforeDinnerfast == "1" || aftDinnerfast == "1"
            {
                ThirdTimeMedicine = "1"
            }else{
                ThirdTimeMedicine = "0"
            }
            
            let medicineTime = FirstTimeMedicine + SecondTimemedicine + ThirdTimeMedicine

          cell.lblMedicinePeriod.text = medicineTime
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        popUp.contentView = ShowMedicineDetailView
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        
        let lcdict = MedicineArr[indexPath.row]
        
        var FirstTimeMedicine = String()
        var SecondTimemedicine = String()
        var ThirdTimeMedicine = String()
        
        let beforeBrkfast = lcdict["beforeBreakfast"] as! String
        let aftBrkfast = lcdict["afterBreakfast"] as! String

        if beforeBrkfast == "1" || aftBrkfast == "1"
        {
           FirstTimeMedicine = "1-"
        }else
        {
             FirstTimeMedicine = "0-"
        }

        let beforeLunchfast = lcdict["beforeLunch"] as! String
        let aftLunchfast = lcdict["afterLunch"] as! String

        if beforeLunchfast == "1" || aftLunchfast == "1"
        {
            SecondTimemedicine = "1-"
        }else
        {
            SecondTimemedicine = "0-"
        }

        let beforeDinnerfast = lcdict["beforeDinner"] as! String
        let aftDinnerfast = lcdict["afterDinner"] as! String

        if beforeDinnerfast == "1" || aftDinnerfast == "1"
        {
            ThirdTimeMedicine = "1"
        }else{
             ThirdTimeMedicine = "0"
        }

        let medicineTime = FirstTimeMedicine + SecondTimemedicine + ThirdTimeMedicine

        lblMedicineTiming.text = "Medicine Timing : \(medicineTime)"

        detailMedicineNm.text = "Medicine Name : \(lcdict["medicineName"] as! String)"
        
        var setType = String()
        let IntervalType = lcdict["intervalType"] as! Int
        
        if IntervalType == 1
        {
            setType = "Daily"
            detailMedicineWeeks.isHidden = true
            
        }else if IntervalType == 2
        {
            setType = "Weekly"
            detailMedicineWeeks.isHidden = false
        }else
        {
            setType = "Time Interval"
            detailMedicineWeeks.isHidden = true
             detailMedicineDays.isHidden = true
        }
        
        detailMedicineType.text = "Medicine Type : \(setType)"
        
        detailMedicineDays.text = "Number of Days : \(lcdict["intervalPeriod"] as! String)"
        
        detailMedicineWeeks.text = "Number of Weeks : \(lcdict["intervalTime"] as! String)"
   
    }
    
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
extension UIImage
{
    func GetFileName() -> String!
    {
        let lcImgName = self.accessibilityIdentifier
        return lcImgName!
    }
}
extension AndriodPrescFormVC : UITextFieldDelegate
{
   
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        if textField == txtHowManyDays
        {
            guard let text = txtHowManyDays.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 3// Bool
        }
        
        if textField == txtHowManyWeeks
        {
            guard let text = txtHowManyWeeks.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 3// Bool
        }
        
        if textField == txtWeight
        {
            guard let text = txtWeight.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 3// Bool
        }
        if textField == txtHeightInFeet
        {
            if txtHeightInFeet.placeholder == "Feet"
            {
                guard let text = txtHeightInFeet.text else { return true }
                let newLength = text.characters.count + string.characters.count - range.length
                
                return newLength <= 1 // Bool
            }
            
            if txtHeightInFeet.placeholder == "Height in Cm"
            {
                guard let text = txtHeightInFeet.text else { return true }
              
                
                let newLength = text.characters.count + string.characters.count - range.length
                
                return newLength <= 3 // Bool
            }
           
        }
        
        if textField == txtHgtInCemi
        {
            guard let text = txtHgtInCemi.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 2 // Bool
        }
        
        
        if textField == txtTemp
        {
            guard let text = txtTemp.text else { return true }
            
           
                let newLength = text.characters.count + string.characters.count - range.length
                
                return newLength <= 3 // Bool
        }
        
        if textField == txtBloodGrp
        {
            guard let text = txtBloodGrp.text else { return true }
            
            
            if txtBloodGrp.text?.characters.count == 3
            {
                txtBloodGrp.text?.append(contentsOf: "/")
            }
            
          self.m_nNewLength = text.characters.count + string.characters.count - range.length
            
                return self.m_nNewLength <= 7
        }
        
        return true
    }
    
    
    
}
