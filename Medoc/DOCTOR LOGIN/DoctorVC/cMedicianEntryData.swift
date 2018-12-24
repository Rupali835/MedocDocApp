//
//  cMedicianEntryData.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/21/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation

class cMedicianEntryData: NSObject
{
    var medicineNm : String
    var medicineTime : String
    var secMedicineTime : String
    var ThirdMedicineTime : String
    
    init(cMedicinenm : String, cMedicinetime : String, cSec : String, cThird : String)
    {
        self.medicineNm = cMedicinenm
        self.medicineTime = cMedicinetime
        self.secMedicineTime = cSec
        self.ThirdMedicineTime = cThird
    }
}
