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
    
    
   
    override func viewDidAppear(_ animated: Bool) {
        if PatientInfo.count != 0
        {
            showData()
        }
    }
    
    
    func showData()
    {
        
        switch checkData
        {
          
        case 2 :
            
            if let cont1 = self.PatientInfo["email"] as? String
            {
                lblOne.text = "Email ID: \(cont1)"
            }else
            {
                lblOne.text = "Email ID: -"
            }
            
            if let cont2 = self.PatientInfo["alt_contact_no"] as? String
            {
                lblTwo.text = "Alt contact no: \(cont2)"
            }else
            {
                lblTwo.text = "Alt contact no: -"
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
                    lblthree.text = "Gender: -"
                }
            }
            
            if let num2 = self.PatientInfo["blood_pressure"] as? String
            {
                lblFour.text = "Blood Pressure: \(num2)"
            }else
            {
                lblFour.text = "Blood Pressure: -"
            }
            
            if let num1 = self.PatientInfo["blood_group"] as? String
            {
                lblFive.text = "Blood Group: \(num1)"
            }else
            {
                lblFive.text = "Blood Group: -"
            }
            
            if let rel2 = self.PatientInfo["p_policy"] as? String
            {
                lblSix.text = "P_policy: \(rel2)"
            }else
            {
                lblSix.text = "P_policy: -"
            }
            
            break
            
        case 3 :
            
            
            if let cont1 = self.PatientInfo["family_history_allergy_details"] as? String
            {
                if cont1 == "0" || cont1 == "" || cont1 == "NF"
                {
                     lblOne.text = "Family History Allergy: NA"
                }else
                {
                    lblOne.text = "Family History Allergy: Yes"
                }
            }
            
            if let cont2 = self.PatientInfo["food_allergy_details"] as? String
            {
                if cont2 == "0" || cont2 == "" || cont2 == "NF"
                {
                    lblTwo.text = "Food Allergy: NA"
                }else
                {
                    lblTwo.text = "Food Allergy: Yes"
                }
            }
            
            if let rel1 = self.PatientInfo["drug_allergy_details"] as? String
            {
                if rel1 == "0" || rel1 == "" || rel1 == "NF"
                {
                    lblthree.text = "Drug Allergy: NA"
                }else
                {
                    lblthree.text = "Drug Allergy: Yes"
                }
            }
            
            if let num2 = self.PatientInfo["environmental_allergy_details"] as? String
            {
                if num2 == "0" || num2 == "" || num2 == "NF"
                {
                    lblFour.text = "Environmental Allergy: NA"
                }else
                {
                    lblFour.text = "Environmental Allergy: Yes"
                }
            }
            
            if let num1 = self.PatientInfo["known_condition_details"] as? String
            {
                if num1 == "0" || num1 == "" || num1 == "NF"
                {
                    lblFive.text = "known condition: NA"
                }else
                {
                    lblFive.text = "known condition: Yes"
                }
            }
            
            if let rel2 = self.PatientInfo["genetic_disorders_details"] as? String
            {
                if rel2 == "0" || rel2 == "" || rel2 == "NF"
                {
                    lblSix.text = "Genetic disorders: NA"
                }else
                {
                    lblSix.text = "Genetic disorders: Yes"
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
