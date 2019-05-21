//
//  HospitalDataModel.swift
//  Medoc
//
//  Created by Rupali Patil on 20/05/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
class HospitalData : Decodable
{
    var msg : String!
    var hospital : [getHospitalList]!
}

struct getHospitalList : Decodable
{
    var id : String?
    var name : String?
    var logo : String?
    var contact : String?
    var address_1 : String?
    var wesite : String?
    var email : String?
    var pincode : String?
}
