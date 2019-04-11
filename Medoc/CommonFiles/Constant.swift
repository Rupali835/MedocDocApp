//
//  Constant.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/20/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation

struct Constant
{
    static let BaseUrl = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/"
    
    static let LoginDoctor = "login"
    static let LogoutDoctor = "logout"
    static let SignIn = "create_doc"
    
    static let getTodaysPatients = "get_todays_patients"
    static let addPatient = "add_patient"
    static let getTotalCountofPatients = "get_counts"
    
    static let TypesOfDoctor = "type_of_doctors"
    static let GetProfileData = "get_doctor_info"
    static let setNewProfileData = "update_doctor"
    
    static let getPatientsDatewise = "get_patients_datewise"
    
    static let UploadFiles = "add_files"
    
    static let getChiegComplains = "get_chief_complaints"
    static let getMedicineData = "get_medicine_data"
    static let getLabtest = "get_lab_test"
    
    static let getPatientInfo = "get_patient_info"
    
    static let get_all_prescription_of_patient = "get_prescription_list_by_patient_id"
    
    static let detail_prescription_of_patient = "detail_prescription"
    
}
