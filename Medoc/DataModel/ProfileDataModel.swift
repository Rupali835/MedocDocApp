//
//  ProfileDataModel.swift
//  Medoc
//
//  Created by Rupali Patil on 16/05/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
class ProfileData : Decodable
{
    var msg : String!
    var data : [profiledata]!
}

struct profiledata: Decodable
{
    var name : String?
    var profile_picture : String?
    var email : String?
    var gender : String?
    var contact_no : String?
    var address : String?
    var website : String?
    var dob : String?
    var specialized_in : String?
    var alt_contact_no : String?
    var registration_no : String?
    var qualification : String?
    var experience : String?
    var designation : String?
    var hospital_added : Bool?
}
