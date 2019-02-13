//
//  OpenPopUpInfoVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/12/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class OpenPopUpInfoVC: UIViewController {

    
    @IBOutlet weak var lblOne: UILabel!
    
    @IBOutlet weak var lblTwo: UILabel!
    
    @IBOutlet weak var lblFive: UILabel!
    
    @IBOutlet weak var lblSix: UILabel!
    @IBOutlet weak var lblFour: UILabel!
    @IBOutlet weak var lblthree: UILabel!
    
    
    var PatientInfo = [String : Any]()
    var checkData = Int()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func setData(info : [String : Any], val : Int)
    {
        self.PatientInfo = info
        self.checkData = val
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if PatientInfo.count != 0
        {
            showData()
        }
    }
    
    func showData()
    {
        
        switch checkData
        {
        case 1 :
            
            if let cont1 = self.PatientInfo["emergency_contact_name1"] as? String
            {
                lblOne.text = "Emergency_contact_name1: \(cont1)"
            }else
            {
                lblOne.text = "Emergency_contact_name1: Not given by patient"
            }
            
            if let cont2 = self.PatientInfo["emergency_contact_name2"] as? String
            {
                lblTwo.text = "Emergency_contact_name2: \(cont2)"
            }else
            {
                lblTwo.text = "Emergency_contact_name2: Not given by patient"
            }
            
            if let num1 = self.PatientInfo["emergency_contact_number1"] as? String
            {
                lblthree.text = "Emergency_contact_number1: \(num1)"
            }else
            {
                lblthree.text = "Emergency_contact_number1: Not given by patient"
            }
            
            if let num2 = self.PatientInfo["emergency_contact_number2"] as? String
            {
                lblFour.text = "Emergency_contact_number2: \(num2)"
            }else
            {
                lblFour.text = "Emergency_contact_number2: Not given by patient"
            }
            
            if let rel1 = self.PatientInfo["emergency_contact_relation1"] as? String
            {
                lblFive.text = "Emergency_contact_relation1: \(rel1)"
            }else
            {
                lblFive.text = "Emergency_contact_relation1: Not given by patient"
            }
            
            if let rel2 = self.PatientInfo["emergency_contact_relation2"] as? String
            {
                lblSix.text = "Emergency_contact_relation2: \(rel2)"
            }else
            {
                lblSix.text = "Emergency_contact_relation2: Not given by patient"
            }
            
            break
            
        case 2 :
            
            if let cont1 = self.PatientInfo["email"] as? String
            {
                lblOne.text = "Email ID: \(cont1)"
            }else
            {
                lblOne.text = "Email ID: NF"
            }
            
            if let cont2 = self.PatientInfo["alt_contact_no"] as? String
            {
                lblTwo.text = "Alt_contact_no: \(cont2)"
            }else
            {
                lblTwo.text = "Alt_contact_no: NF"
            }
            
            if let rel1 = self.PatientInfo["gender"] as? String
            {
                if rel1 == "1"
                {
                    lblthree.text = "Gender: Male"
                }
                else if rel1 == "2"
                {
                    lblthree.text = "Gender: Female"
                }else
                {
                    lblthree.text = "Gender: NF"
                }
            }
            
            if let num2 = self.PatientInfo["blood_pressure"] as? String
            {
                lblFour.text = "Blood Pressure: \(num2)"
            }else
            {
                lblFour.text = "Blood Pressure: NF"
            }
            
            if let num1 = self.PatientInfo["blood_group"] as? String
            {
                lblFive.text = "Blood Group: \(num1)"
            }else
            {
                lblFive.text = "Blood Group: NF"
            }
            
            if let rel2 = self.PatientInfo["p_policy"] as? String
            {
                lblSix.text = "P_policy: \(rel2)"
            }else
            {
                lblSix.text = "P_policy: NF"
            }
            
            break
            
        case 3 :
            
            
            if let cont1 = self.PatientInfo["allergy"] as? String
            {
                if cont1 == "0"
                {
                     lblOne.text = "Allergy: NA"
                }else
                {
                    lblOne.text = "Allergy: Yes"
                }
            }
            
            if let cont2 = self.PatientInfo["cancer"] as? String
            {
                if cont2 == "0"
                {
                    lblTwo.text = "Cancer: NA"
                }else
                {
                    lblTwo.text = "Cancer: Yes"
                }
            }
            
            if let rel1 = self.PatientInfo["diabetes"] as? String
            {
                if rel1 == "0"
                {
                    lblthree.text = "Diabetes: NA"
                }else
                {
                    lblthree.text = "Diabetes: Yes"
                }
            }
            
            if let num2 = self.PatientInfo["food_alergy"] as? String
            {
                if num2 == "0"
                {
                    lblFour.text = "Food Alergy: NA"
                }else
                {
                    lblFour.text = "Food Alergy: Yes"
                }
            }
            
            if let num1 = self.PatientInfo["insects_allergy"] as? String
            {
                if num1 == "0"
                {
                    lblFive.text = "Insects Allergy: NA"
                }else
                {
                    lblFive.text = "Insects Allergy: Yes"
                }
            }
            
            if let rel2 = self.PatientInfo["lukemia"] as? String
            {
                if rel2 == "0"
                {
                    lblSix.text = "Lukemia: NA"
                }else
                {
                    lblSix.text = "Lukemia: Yes"
                }
            }
        
            break
        
            
        default:
            print("")
        }
        

    }
    
    @IBAction func btnOk_onClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    

}
