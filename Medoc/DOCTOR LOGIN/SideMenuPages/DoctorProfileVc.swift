//
//  DoctorProfileVc.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/11/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Charts

class DoctorProfileVc: UIViewController, UIImagePickerControllerDelegate {

    // Profile Other Info label
    
    @IBOutlet weak var analysisChart: LineChartView!
    @IBOutlet weak var otherInfoView: Cardview!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblbp: UILabel!
    @IBOutlet weak var lblBloodGrp: UILabel!
    
    // Profile BaseInfo label
    @IBOutlet weak var baseInfoView: Cardview!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblAltPhone: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    // ADD OTHER INFO POPUP
    
    @IBOutlet var klcOtherInfo: UIView!
    @IBOutlet weak var btnSaveOtherInfo: UIButton!
    @IBOutlet weak var btncancelOtherInfo: UIButton!
    @IBOutlet weak var txtNotes: HoshiTextField!
    @IBOutlet weak var txtheight: HoshiTextField!
    @IBOutlet weak var txtWeight: HoshiTextField!
    @IBOutlet weak var txtBp: HoshiTextField!
    @IBOutlet weak var txtbldgrp: HoshiTextField!
    
    // ADD BASE INFO POPUP
    @IBOutlet var klcBaseInfo: UIView!
    @IBOutlet weak var btnFemale: DLRadioButton!
    @IBOutlet weak var btnmale: DLRadioButton!
    @IBOutlet weak var btnSaveBaseInfo: UIButton!
    @IBOutlet weak var btnCancelBaseInfo: UIButton!
    @IBOutlet weak var txtDob: HoshiTextField!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var txtAltPhone: HoshiTextField!
    @IBOutlet weak var txtAge: HoshiTextField!
  
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var lblRegNo: UILabel!
    @IBOutlet weak var countPresc: UILabel!
    @IBOutlet weak var countMonthlyPatients: UILabel!
    @IBOutlet weak var countTodaysPatients: UILabel!
    @IBOutlet weak var lbleducation: UILabel!
    @IBOutlet weak var lblcontact: UILabel!
    @IBOutlet weak var lblDrName: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var clinicInfoView: Cardview!
    var popUp = KLCPopup()
    
    @IBOutlet weak var addClinicView: Cardview!
    @IBOutlet weak var btnAddClinic: UIButton!
    
    var profileData = [AnyObject]()
    var last_30_days_data = [AnyObject]()
    var Arr_last_30_days_datavalues = [Double]()
    var xAxisValue = [String]()
    var img_path = "http://medoc.co.in/medoc_doctor_api/uploads/"
    var toast = JYToast()
    var h_listArr = [getHospitalList]()
    var Login_id = Int()
    var selectedImage: UIImage!
    var fileName: String!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnmale.isMultipleSelectionEnabled = false
        setLayout(btnItem: [btnSaveBaseInfo, btnCancelBaseInfo, btnSaveOtherInfo, btncancelOtherInfo])
        self.GestureBaseInfo()
        self.GestureOtherInfo()
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openCam))
        
        self.userPic.addGestureRecognizer(tap)
        self.userPic.isUserInteractionEnabled = true
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        Login_id = dict["id"] as! Int
        let Role = dict["role_id"] as! String
        
        GetDoctorProfile(Id: Login_id)
        axisFormatDelegate = self
        GetCount(id: Login_id, role: Role)
        
    }
    
    @objc func openCam()
    {
        
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            
            let timestamp = Date().toMillis()
            image.accessibilityIdentifier = String(describing: timestamp)
             self.selectedImage = image
            self.fileName = String(describing: timestamp!) + ".jpeg"
            self.userPic.image = image
            self.userPic.contentMode = .scaleAspectFit
     
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
    
        sideMenus()
    }

    func setLayout(btnItem: [UIButton])
    {
        for btn in btnItem
        {
            btn.layer.cornerRadius = 10
            btn.layer.borderWidth = 0.8
            btn.layer.borderColor = UIColor.black.cgColor
        }
      
    }
    
    func GestureBaseInfo()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openBaseInfo))
        baseInfoView.isUserInteractionEnabled = true
        baseInfoView.addGestureRecognizer(tap)
        
    }
  
    func GestureOtherInfo()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openOtherInfo))
        otherInfoView.isUserInteractionEnabled = true
        otherInfoView.addGestureRecognizer(tap)
    }
    
    @IBAction func btnCancelotherInfo_onClick(_ sender: Any)
    {
        self.popUp.dismiss(true)
    }
    
    @IBAction func btnSaveOtherInfo_onclick(_ sender: Any)
    {
        self.lblBloodGrp.text = "Blood Group : \(txtbldgrp.text ?? "")"
        self.lblbp.text = "Blood Pressure : \(txtBp.text ?? "")"
        self.lblWeight.text = "Weight : \(txtWeight.text ?? "")"
        self.lblHeight.text = "Height : \(txtheight.text ?? "")"
        self.lblNotes.text = "Notes : \(txtNotes.text ?? "")"
        self.popUp.dismiss(true)
    }
    
    @IBAction func btnCancel_onclick(_ sender: Any)
    {
        self.popUp.dismiss(true)
    }
    
    @IBAction func btnSave_onclick(_ sender: Any)
    {
        self.lblAge.text = "Age : \(txtAge.text ?? "")"
        self.lblDob.text = "DOB : \(txtDob.text ?? "")"
        self.lblAltPhone.text = "Alt Phone : \(txtAltPhone.text ?? "")"
        self.lblAddress.text = "Address : \(txtAddress.text ?? "")"
        
        self.popUp.dismiss(true)
        
    }
    
    @IBAction func btnMale_onclick(_ sender: Any)
    {
        _ = btnmale.selected()?.titleLabel!.text
        self.lblGender.text = "Gender: Male"
    }
    
    @IBAction func btnFemale_onclick(_ sender: Any)
    {
        _ = btnFemale.selected()?.titleLabel!.text
        self.lblGender.text = "Gender : Female"
    }
    
    @objc func openBaseInfo()
    {
        klcOtherInfo.isHidden = true
        klcBaseInfo.isHidden = false
        popUp.contentView = klcBaseInfo
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.layer.cornerRadius = 10
    popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    @objc func openOtherInfo()
    {
        klcOtherInfo.isHidden = false
        klcBaseInfo.isHidden = true
        popUp.contentView = klcOtherInfo
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.layer.cornerRadius = 10
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            self.btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            if UIDevice.current.userInterfaceIdiom == .pad {
                revealViewController().rearViewRevealWidth = 400
                revealViewController().rightViewRevealWidth = 180
            } else {
                revealViewController().rearViewRevealWidth = 260
                revealViewController().rightViewRevealWidth = 180
            }
        }
    }
    
    @IBAction func btnback_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)

    }
    
    func GetDoctorProfile(Id : Int)
    {
        
        let get_profile = Constant.BaseUrl+Constant.GetProfileData
        
        let param = ["loggedin_id" : Id]
        
        Alamofire.request(get_profile, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                do{
                    let json = try JSONDecoder().decode(ProfileData.self, from: resp.data!)
                    
                    if json.msg == "success"
                    {
                        let profileData = json.data!
                        
                        for lcdata in profileData
                        {
                            self.lblDrName.text = lcdata.name
                            self.lblemail.text = lcdata.email
                            self.lblcontact.text = lcdata.contact_no
                            
                            if let regNo = lcdata.registration_no
                            {
                                self.lblRegNo.text = regNo
                            }
                       
                            if let profilePic = lcdata.profile_picture
                            {
                                if (profilePic != "NF") && (profilePic != "")
                                {
                                    let str = "\(self.img_path)\(profilePic)"
                                    let ImgUrl = URL(string: str)
                                    self.userPic.kf.setImage(with: ImgUrl)
                                    self.userPic.contentMode = .scaleAspectFit
                                    
                                    
                                }else{
                                    self.userPic.image = UIImage(named: "user")
                                    self.userPic.contentMode = .center
                                    self.userPic.tintColor = UIColor.black
                                }
                                
                            }
                         
                        }
                     
                    }
                }catch{
                    self.toast.isShow("Something went wrong")
                }

                
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    func GetCount(id: Int, role: String)
    {
        let countApi = Constant.BaseUrl+Constant.getTotalCountofPatients
        
        let Parm = ["loggedin_id" : id,
                    "loggedin_role" : role] as [String : Any]
        
        Alamofire.request(countApi, method: .post, parameters: Parm).responseJSON { (resp) in
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                print("Get Count: \(json)")
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    let CountArr = json["data"] as! [AnyObject]
                    
                    self.xAxisValue.removeAll()
                    self.Arr_last_30_days_datavalues.removeAll()
                    
                    for lcdata in CountArr
                    {
                        self.countTodaysPatients.text = String(lcdata["ptt_total"] as! Int)
                        self.countMonthlyPatients.text = String(lcdata["m_new"] as! Int)
                        self.countPresc.text = String(lcdata["prescription_total"] as! Int)
                        self.last_30_days_data = lcdata["last_30_days_data"] as! [AnyObject]
                    }
                    for data in self.last_30_days_data {
                        let count = data["count"] as! String
                        let date = data["date"] as! String
                        
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd"
                        let getdateformate = df.date(from: date)
                        
                        let dateformatter2 = DateFormatter()
                        dateformatter2.dateFormat = "d MMM"
                        let datestr = dateformatter2.string(from: getdateformate!)
                        
                        self.Arr_last_30_days_datavalues.append(count.toDouble()!)
                        self.xAxisValue.append(datestr)
                    }
                    DispatchQueue.main.async {
                        self.setChart(dataPoints: self.xAxisValue, values: self.Arr_last_30_days_datavalues)
                        
                    }
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
                
                
            }
        }
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for (i,_) in values.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i],data: dataPoints as AnyObject)
            dataEntries.append(dataEntry)
        }
        var chartData = ChartData()
        var chartDataSet = LineChartDataSet()
        
        chartDataSet = LineChartDataSet(values: dataEntries, label: "last 30 days data")
        chartData = LineChartData(dataSets: [chartDataSet])
        
        let gradColors = [UIColor.red.withAlphaComponent(0.7).cgColor, UIColor.orange.cgColor]
        let colorLocations:[CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            chartDataSet.fill = Fill(linearGradient: gradient, angle: 90.0)
            chartDataSet.drawFilledEnabled = true
            chartDataSet.lineDashPhase = 0.5
        }
        analysisChart.data = chartData
        analysisChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        analysisChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        analysisChart.rightAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 10)
        
        let xAxisValue = analysisChart.xAxis
        xAxisValue.granularityEnabled = true
        xAxisValue.granularity = 1.0
        xAxisValue.spaceMin = 0.5
        xAxisValue.spaceMax = 0.5
        xAxisValue.labelPosition = .bottom
        analysisChart.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.linear)
        xAxisValue.valueFormatter = axisFormatDelegate
        
        self.analysisChart.notifyDataSetChanged()
        chartData.notifyDataChanged()
    }
}
extension DoctorProfileVc: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xAxisValue[Int(value) % xAxisValue.count]
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
