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
    
    @IBOutlet weak var btnBack: UIButton!
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String?
    var patientList = [AnyObject]()
    var ColorArr = [UIColor]()
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collView.delegate = self
        collView.dataSource = self
        
        calendar.delegate = self
        calendar.dataSource = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        
        self.DateStr = stringDate
        getPatientList(sDate: self.DateStr!)
        
         self.ColorArr = [UIColor.MKColor.Red.P400, UIColor.MKColor.Blue.P400, UIColor.MKColor.Orange.P400, UIColor.MKColor.Green.P400, UIColor.MKColor.Indigo.P400, UIColor.MKColor.Amber.P400, UIColor.MKColor.LightBlue.P400, UIColor.MKColor.BlueGrey.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Cyan.P400, UIColor.MKColor.Teal.P400, UIColor.MKColor.Lime.P400, UIColor.MKColor.Pink.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Purple.P400]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    func getPatientList(sDate : String)
    {
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        let id = dict["id"] as? Int
        let Role = dict["role_id"] as? String
        
   
        let Api = Constant.BaseUrl+Constant.getPatientsDatewise
        
        let param = ["loggedin_id" : id!,
                     "loggedin_role" : Role!,
                     "date" : sDate] as [String : Any]
        
        print(param)
        
        self.view.activityStartAnimating(activityColor: UIColor.black, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            self.view.activityStopAnimating()
            
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
            if UIDevice.current.userInterfaceIdiom == .pad {
                revealViewController().rearViewRevealWidth = 400
                revealViewController().rightViewRevealWidth = 180
            } else {
                revealViewController().rearViewRevealWidth = 260
                revealViewController().rightViewRevealWidth = 180
            }
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    
    @IBAction func btnback_Onclick(_ sender: Any)
    {
   
    }
    
  
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}
extension AppointmentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        var appstory = AppStoryboard.Doctor
        if UIDevice.current.userInterfaceIdiom == .pad {
            appstory = AppStoryboard.Doctor
        } else {
            appstory = AppStoryboard.IphoneDoctor
        }
        let presclistvc = appstory.instance.instantiateViewController(withIdentifier: "PatientPrescriptionListVC") as! PatientPrescriptionListVC
        presclistvc.viewFromAppoinment = true
        presclistvc.dataFromAppoinment = lcdict as! [String : Any]
        self.navigationController?.pushViewController(presclistvc, animated: true)
//        self.present(presclistvc, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2

      //  return CGSize(width: UIScreen.main.bounds.size.width/2, height: 100)
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: (self.collView.frame.size.width - 30), height: 100)
        }
        return CGSize(width: (self.collView.frame.size.width - 30) / 2, height: 100)
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
extension AppointmentVC : FSCalendarDelegate, FSCalendarDataSource
{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let dateString = self.formatter.string(from: date)

        print("did select date \(dateString)")
        getPatientList(sDate: dateString)
        
        //self.configureVisibleCells()
    }
    
}
