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



class DoctorProfileVc: UIViewController, UIImagePickerControllerDelegate {

    // Profile Other Info label
    
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
    
    @IBOutlet weak var addClinicSmallView: UIView!
    @IBOutlet weak var clinicInfoView: Cardview!
    @IBOutlet weak var collClinic: UICollectionView!
    var popUp = KLCPopup()
    
    @IBOutlet weak var addClinicView: Cardview!
    @IBOutlet weak var btnAddClinic: UIButton!
    
    var profileData = [AnyObject]()
    var img_path = "http://medoc.co.in/medoc_doctor_api/uploads/"
    var toast = JYToast()
    var h_listArr = [getHospitalList]()
    var Login_id = Int()
    var selectedImage: UIImage!
    var fileName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnmale.isMultipleSelectionEnabled = false
        setLayout(btnItem: [btnSaveBaseInfo, btnCancelBaseInfo, btnSaveOtherInfo, btncancelOtherInfo])
        self.GestureBaseInfo()
        self.GestureOtherInfo()
        self.collClinic.delegate = self
        self.collClinic.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openCam))
        
        self.userPic.addGestureRecognizer(tap)
        self.userPic.isUserInteractionEnabled = true
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        Login_id = dict["id"] as! Int
        let Role = dict["role_id"] as! String
        
        let hospialAddedKey = dict["hospital_added"] as! Bool
        
        self.addClinicView.isHidden = hospialAddedKey ? true : false
        
        hospialAddedKey ? setHidden(bStatus: false) : setHidden(bStatus: true)
        
        GetDoctorProfile(Id: Login_id)
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
      //      self.btnProfileImg.setImage(image, for: .normal)
            
           
            
        }
    }
    
    func setHidden(bStatus: Bool)
    {
        self.addClinicSmallView.isHidden = bStatus // add clinic btn second
        self.clinicInfoView.isHidden     = bStatus
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
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
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
                          
                            if let hospital_added = lcdata.hospital_added
                            {
                                hospital_added ? self.setHidden(bStatus: false) : self.setHidden(bStatus: true)
                               
                                if hospital_added
                                {
                                  self.getHospital(id: self.Login_id)
                                }
                                
                self.addClinicView.isHidden = hospital_added ? true : false
                                
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
                
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    let CountArr = json["data"] as! [AnyObject]
                    
                    for lcdata in CountArr
                    {
                        self.countTodaysPatients.text = String(lcdata["ptt_total"] as! Int)
                        self.countMonthlyPatients.text = String(lcdata["m_new"] as! Int)
                        self.countPresc.text = String(lcdata["prescription_total"] as! Int)
                      
                    }
                }
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
                
                
            }
        }
    }
    
    func getHospital(id : Int)
    {
        let Api = Constant.BaseUrl + Constant.getClinic
        let param = ["loggedin_id" : id]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                do{
                   
                    let json = try JSONDecoder().decode(HospitalData.self, from: resp.data!)
                    
                    if json.msg == "success"
                    {
                       self.h_listArr = json.hospital
                        
                       // self.clinicInfoView.isHidden = false
                        self.addClinicView.isHidden = true
                        //self.addClinicSmallView.isHidden = false
                        self.setHidden(bStatus: false)
                        
                        self.collClinic.reloadData()
                        
                    }else
                    {
                        Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "No Hospital Added")
                    }
                    
                }catch{
                    Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "\(error.localizedDescription)")
                }
                break
                
            case .failure(_):
                break
                
            }
            
        }
    }
    
    @IBAction func btnAddClinic_onclick(_ sender: Any)
    {
        let VC1 = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddClinicVC") as! AddClinicVC
        VC1.delegate = self
        self.present(VC1, animated:true, completion: nil)
    }
}
extension DoctorProfileVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return h_listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collClinic.dequeueReusableCell(withReuseIdentifier: "getHospitalCell", for: indexPath) as! getHospitalCell
        
        let lcdict = h_listArr[indexPath.item]
        cell.lblClinicNm.text = lcdict.name
        
        if lcdict.email != ""
        {
             cell.lblClinicEmail.text = lcdict.email
        }else{
            cell.lblClinicEmail.text = "not provided"
        }
      
        cell.lblClinicNumber.text = lcdict.contact
        if lcdict.logo != "NF" && lcdict.logo != ""
        {
            let str = "\(self.img_path)\(lcdict.logo!)"
            let imgUrl = URL(string: str)
            cell.imgClinicLogo.kf.setImage(with: imgUrl)
        }else
        {
            cell.imgClinicLogo.image = UIImage(named: "AppIcon")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            // return CGSize(width: (self.collPatientList.frame.size.width - 10) / 3, height: 70)
            return CGSize(width: (self.collClinic.frame.size.width - 30) / 2, height: 150)
       
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
extension DoctorProfileVc : AddClinicProtocol
{
    func addClinicInprofile() {
        self.getHospital(id: self.Login_id)
    }
}
