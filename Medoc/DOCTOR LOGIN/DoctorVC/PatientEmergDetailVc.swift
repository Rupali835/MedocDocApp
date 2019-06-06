//
//  PatientEmergDetailVc.swift
//  Medoc
//
//  Created by Rupali Patil on 05/06/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class PatientEmergDetailVc: UIViewController {
  
    
        // Guardian detail
    @IBOutlet weak var lblGuardianNm: UILabel!
    @IBOutlet weak var lblGuardianPhone: UILabel!
    @IBOutlet weak var lblGuardianAdreess: UILabel!
    
        // Primary Emergency Detail
    @IBOutlet weak var lblPrimaryEmergNm: UILabel!
    @IBOutlet weak var lblPrimaryEmrgContact: UILabel!
    @IBOutlet weak var lblPrimaryEmrgRelation: UILabel!
    
    // Secondary Emergency Detail
    @IBOutlet weak var lblSecndEmrgNm: UILabel!
    @IBOutlet weak var lblSecndEmrgContact: UILabel!
    @IBOutlet weak var lblSecndEmrgRelation: UILabel!
    
    @IBOutlet weak var lblPhysicianNm: UILabel!
    
    @IBOutlet weak var lblPhysicianContact: UILabel!
    var PatientEmrgInfo = [String : Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
  
    override func viewDidAppear(_ animated: Bool) {
        print("Emergency details : \(PatientEmrgInfo)")
        
        setData()
   /*
        ["drug_allergy_details": [],
         "forgot_password_otp": <null>,
         "address1": Saki Naka,
         "created_at": 2019-04-05 10:22:15,
         "gaurdian_city": Mumbai,
         "inactivated_at": <null>,
         "known_condition_details": [],
         "guid": 3382bf98a4d8411e,
         "id": 122,
         "doctor_id": 197,
         "food_allergy_details": ["Cheese"],
         "updated_at": 2019-06-05 12:42:11,
         "inactivated_by": <null>,
         "relationship": , "last_tetanus_date": <null>,
         "name": Prashant S.,
         "emergency_contact_relation2": <null>,
         "p_policy": M$123,
         "password": $2y$10$LsuQ5OnYq5PSpLlD0EEAJeUIO9ogxAH1JAITv2MD6V2rnMTsPqU6y, "email": prashant@gmail.com,
         "p_policy_number": 0,
         "gaurdian_name": Jamal S,
         "city": Mumbai,
         "genetic_disorders_details": [],
         "is_active": 1,
         "sub_city": Andheri,
         "dob": 1990-11-23,
         "emergency_contact_name2": <null>,
         "environmental_allergy_details": [],
         "gaurdian_pincode": <null>,
         "emergency_contact_number2": <null>,
         "emergency_contact_number1": 9517532580,
         "created_by": 197,
         "family_history_allergy_details": [],
         "profile_picture": NF,
         "alt_contact_no": <null>,
         "last_diptheria_date": <null>,
         "blood_group": O+,
         "contact_no": 8108091854,
         "activated_at": <null>,
         "gaurdian_address1": <null>,
         "personal_physician_contact": 8642097159,
         "last_polio_date": 1961-04-13,
         "pincode": 400032,
         "activated_by": <null>,
         "address2": <null>,
         "last_mumps_date": <null>,
         "emergency_contact_name1": Atul,
         "gender": 1,
         "updated_by": <null>,
         "gaurdian_subcity": <null>,
         "patient_id": Pra51554439936,
         "fcm_token": f7jC8dCJKCQ:APA91bHAJH7w5KPlx3p_C5p9YeuQFlQc4ZcvwfrR2DqkefNx4wLUT4MG5I42mgOG1sUEDy6u8YqChVbSPUmJWOHCYOrfgiR8_fASBa-xnht_oBSwWwS5D8mahvOmZ9XG-nHFjbnesWgW,
         "gaurdian_contact": 8642839562,
         "personal_physician_name": Dr.Madhav,
         "gaurdian_address2": <null>,
         "emergency_contact_relation1": Brother]
       */
    }
    
    func setData()
    {
        if let name = self.PatientEmrgInfo["gaurdian_name"] as? String
        {
            lblGuardianNm.text = name
        }else{
            lblGuardianNm.text = "Not given by patient"
        }
        
        if let contact = self.PatientEmrgInfo["gaurdian_contact"] as? String
        {
            lblGuardianPhone.text = contact
        }else{
            lblGuardianPhone.text = "Not given by patient"
        }
        
        if let addressCity = self.PatientEmrgInfo["gaurdian_city"] as? String
        {
            lblGuardianAdreess.text = addressCity
        }else{
            lblGuardianAdreess.text = "Not given by patient"
        }
        
        if let epname = self.PatientEmrgInfo["emergency_contact_name1"] as? String
        {
            lblPrimaryEmergNm.text = epname
        }else{
            lblPrimaryEmergNm.text = "Not given by patient"
        }
        
        if let epcontact = self.PatientEmrgInfo["emergency_contact_number1"] as? String
        {
            lblPrimaryEmrgContact.text = epcontact
        }else{
            lblPrimaryEmrgContact.text = "-"
        }
        
        if let eprelation = self.PatientEmrgInfo["emergency_contact_relation1"] as? String
        {
           lblPrimaryEmrgRelation.text = eprelation
        }else{
            lblPrimaryEmrgRelation.text = "-"
        }
        
        if let esname = self.PatientEmrgInfo["emergency_contact_name2"] as? String
        {
            lblSecndEmrgNm.text = esname
        }else{
            lblSecndEmrgNm.text = "Not given by patient"
        }
        
        if let escontact = self.PatientEmrgInfo["emergency_contact_number2"] as? String
        {
            lblSecndEmrgContact.text = escontact
        }else{
            lblSecndEmrgContact.text = "-"
        }
        
        if let esrelation = self.PatientEmrgInfo["emergency_contact_relation2"] as? String
        {
            lblSecndEmrgRelation.text = esrelation
        }else{
            lblSecndEmrgRelation.text = "-"
        }
        
        if let phname = self.PatientEmrgInfo["personal_physician_name"] as? String
        {
            lblPhysicianNm.text = phname
        }else{
            lblPhysicianNm.text = "Not given"
        }
        
        if let phcontact = self.PatientEmrgInfo["personal_physician_contact"] as? String
        {
            lblPhysicianContact.text = phcontact
        }else{
            lblPhysicianContact.text = "Not given"
        }
    }
    
    @IBAction func btnCancel_onclick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
}
