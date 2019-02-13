//
//  ViewMoreDetailVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/24/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire

class ViewMoreDetailVC: UIViewController
{
    
    @IBOutlet weak var collMedicine: UICollectionView!
    @IBOutlet weak var collLabTest: UICollectionView!
    @IBOutlet weak var collChiefComplain: UICollectionView!
    @IBOutlet weak var complainView: UIView!
    @IBOutlet weak var medicineView: UIView!
    @IBOutlet weak var btnBldPressure: UIButton!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var labTestView: UIView!
    @IBOutlet weak var diebeticView: UIView!
    
    var InfoArr = [[String : Any]]()
    var ChiefComplainARR = [String : Int]()
    var toast = JYToast()
    
    var MedicineARR = ["Crocin (2)", "Vitamin-B (1)", "Tylenol (2)", "Pepto-Bismol (3)", "Kaopectate (1)", "Bismuth (1)", "Tylenol (2)", "ibuprofen (1)"]
    
    var LabTestARR = ["DENGUE FEVER IGM ANTIBODY (1)", "DIABETES SCREEN (3)", "FEVER PANEL 1 (3)", "HIV 1 & 2 ANTIBODIES (1), SCREENING TEST (1)", "X-RAY ANKLE & FOOT (1)", "URINE (2)", "GLUCOSE (3)"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setDelegte()
        
//        let dict = UserDefaults.standard.value(forKey: "PatientDict") as! [String : Any]
//
//        let Pid = dict["patient_id"] as! String
    
        LayoutView(view: [medicineView, labTestView, graphView, diebeticView, complainView])
        
        if ChiefComplainARR.count != 0
        {
            collChiefComplain.reloadData()
        }
    
        
    }
    
    func setDelegte()
    {
        collChiefComplain.delegate = self
        collChiefComplain.dataSource = self
        collMedicine.dataSource = self
        collMedicine.delegate = self
        collLabTest.delegate = self
        collLabTest.dataSource = self
    }
    
    func LayoutView(view : [UIView])
    {
        for subView in view
        {
            subView.layer.cornerRadius = 10.0
     
            subView.designCell()
            
            subView.backgroundColor = UIColor.white
        }
      
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChartOne_onclick(_ sender: Any)
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ChartAnalysisVC") as! ChartAnalysisVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 }
extension ViewMoreDetailVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collChiefComplain
        {
            return self.ChiefComplainARR.count
        }else if collectionView == collMedicine
        {
            return self.MedicineARR.count
        }else if collectionView == collLabTest
        {
            return self.LabTestARR.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       if collectionView == collChiefComplain
        {
             let cell = collChiefComplain.dequeueReusableCell(withReuseIdentifier: "ChiefComplainAnalysisCell", for: indexPath) as! ChiefComplainAnalysisCell
            
            let key = Array(self.self.ChiefComplainARR.keys)[indexPath.row]
            let value = Array(self.self.ChiefComplainARR.values)[indexPath.row]
            
            var count = String()
            
            if ((key as? String) != nil)
            {
                if value == 1
                {
                    count = "(\(value) time)"
                }else
                {
                    count = "(\(value) times)"
                }
                
                cell.lblChiefComplain.text = "\(key) \(count)"
            }
            
            return cell
        }
       else if collectionView == collMedicine
       {
        let Mcell = collMedicine.dequeueReusableCell(withReuseIdentifier: "MedicineAnalysisCell", for: indexPath) as! MedicineAnalysisCell
        
        Mcell.lblMedicineNm.text = self.MedicineARR[indexPath.row]
        return Mcell
        
        }
        else if collectionView == collLabTest
       {
        let Lcell = collLabTest.dequeueReusableCell(withReuseIdentifier: "LabTestAnalysisCell", for: indexPath) as! LabTestAnalysisCell
        Lcell.lblLabTestNm.text = self.LabTestARR[indexPath.row]
        return Lcell
        }
       else
       {
        return UICollectionViewCell()
        }
     }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.collChiefComplain.frame.size.width) / 2, height: 120)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    //4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
}

