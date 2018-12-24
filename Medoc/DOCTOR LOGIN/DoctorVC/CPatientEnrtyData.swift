//
//  CPatientEnrtyData.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation

class CPatientEntryData: NSObject
{
    var name : String
    var p_description : String
    var patient_id : String
  
    
    init(pName: String, pContact: String, pDescp: String) {
        self.name      = pName
        self.p_description = pContact
        self.patient_id     = pDescp
      
    }
    
}
