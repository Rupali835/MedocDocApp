//
//  PatientPrescriptionListDataModel.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/8/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class PatientPrescriptionList: Decodable
{
    var msg: String!
    var prescriptions : [Prescriptions]!
    var medicines : [Medicines]!
    var reports : [Reports]!
    var last_prescription_by : LastPrescBy?
    var phq : [Phq9]!
    
}
struct Prescriptions: Decodable
{
    var id : String!
    var patient_id : String!
    var doctor_id : String!
    var temperature : String!
    var weight : String!
    var height : String!
    var blood_pressure : String!
    var refered_by : String!
    var patient_problem : String!
    var prescription_details : String!
    var handwritten_image : String!
    var drawing_image : String!
    var signature_image : String!
    var other_details : String!
    var lab_test : String!
    var prescription_pdf : String!
    var pdf_generated_by : String!
    var created_by : String!
    var created_at : String!
}

struct Medicines: Decodable
{
    var id : String!
    var patient_id : String!
    var prescription_id : String!
    var medicine_name : String!
    var interval_period : String!
    var interval_type : String!
    var interval_time : String!
    var interval_period_remaining : String!
    var interval_time_remaining : String!
    var before_bf : String!
    var before_bf_time : String!
    var after_bf : String!
    var after_bf_time : String!
    var before_lunch : String!
    var before_lunch_time : String!
    var after_lunch : String!
    var after_lunch_time : String!
    var before_dinner : String!
    var before_dinner_time : String!
    var after_dinner : String!
    var after_dinner_time : String!
    var created_at : String!
    var created_by : String!
    var updated_at : String!
    var alternative_days : String?
}
struct Reports: Decodable
{
    var report_id : String!
    var patient_id : String!
    var prescription_id : String!
    var image_name : String!
    var tag : String!
    var created_by : String!
    var created_at : String!
}
struct LastPrescBy: Decodable
{
    var name : String?
}

struct Phq9: Decodable
{
    var created_at : String!
    var created_by : String!
    var final_ans : String!
    var id : String!
    var patient_id : String!
    var que_ans : String!
}
