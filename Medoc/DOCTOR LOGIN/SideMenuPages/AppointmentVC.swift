//
//  AppointmentVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/16/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import ZAlertView

class AppointmentVC: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String?
    var patientList = [AnyObject]()
    var ColorArr = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker()
        
        collView.delegate = self
        collView.dataSource = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        let txt = "Appointment Date :"
        
        self.txtDate.text = txt + stringDate
        self.DateStr = stringDate
        getPatientList()
        
         self.ColorArr = [UIColor.MKColor.Red.P400, UIColor.MKColor.Blue.P400, UIColor.MKColor.Orange.P400, UIColor.MKColor.Green.P400, UIColor.MKColor.Indigo.P400, UIColor.MKColor.Amber.P400, UIColor.MKColor.LightBlue.P400, UIColor.MKColor.BlueGrey.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Cyan.P400, UIColor.MKColor.Teal.P400, UIColor.MKColor.Lime.P400, UIColor.MKColor.Pink.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Purple.P400]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    func getPatientList()
    {
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        let id = dict["id"] as? Int
        let Role = dict["role_id"] as? String
        
        let Api = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_patients_datewise"
        
        let param = ["loggedin_id" : id!,
                     "loggedin_role" : Role!,
                     "date" : self.DateStr!] as [String : Any]
        
        print(param)
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.collView.isHidden = false
                    self.patientList = json["data"] as! [AnyObject]
                    self.collView.reloadData()
                }
                if Msg == "fail"
                {
                    self.collView.isHidden = true
                    ZAlertView.init(title: "Medoc", msg: "No patients for selected date.", actiontitle: "OK")
                    {
                        print("")
                    }
                }
                
                break
                
            case .failure(_):
                break
            }
            
        }
        
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnBack.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    
    @IBAction func btnback_Onclick(_ sender: Any)
    {
    }
    
    // MARK : DATEPICKER
    
    func createDatePicker()
    {
        _ = Date()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelPicker))
        
        toolBar.setItems([barBtnItem, barBtnCancel], animated: false)
        
        txtDate.inputAccessoryView = toolBar
        txtDate.inputView = datepicker
        
    }
    
    @objc func donePresses()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let txt = "Appointment Date"
        txtDate.text = txt + "  " + dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
        self.view.endEditing(true)
        getPatientList()
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

}
extension AppointmentVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.patientList != nil
        {
            return self.patientList.count
        }else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
           let randomColor = ColorArr[Int(arc4random_uniform(UInt32(ColorArr.count)))]
        
        let lcdict = self.patientList[indexPath.row]
      
        let index = indexPath.row + 1
        
        cell.lblPatientnm.text = (lcdict["name"] as! String)
        cell.lblnumber.text = String(index)
        cell.lblnumber.backgroundColor = randomColor
        cell.backview.designCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let lcdict = self.patientList[indexPath.row]
        let presclistvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PatientPrescriptionListVC") as! PatientPrescriptionListVC
        presclistvc.viewFromAppoinment = true
        presclistvc.dataFromAppoinment = lcdict as! [String : Any]
        self.navigationController?.pushViewController(presclistvc, animated: true)
//        self.present(presclistvc, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.collView.frame.size.width - 100) / 2, height: 120)
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
