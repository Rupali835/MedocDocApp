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
    var P_name : String
    var P_Contact : String
    var P_Email : String
    var P_problems : String
    
    init(pName: String, pContact: String, pEmail: String, pProblems: String) {
        self.P_name      = pName
        self.P_Contact   = pContact
        self.P_Email     = pEmail
        self.P_problems    = pProblems
    }
    
}
