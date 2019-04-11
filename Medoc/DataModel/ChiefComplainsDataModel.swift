//
//  ChiefComplainsDataModel.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/9/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation

class ChiefComplainsDataModel: Decodable
{
    var msg : String!
    var data : [m_cChiefComplain]!
}

class m_cChiefComplain: Decodable
{
    var id : String!
    var name : String!
}

class labTestDataModel : Decodable
{
    var msg : String!
    var data : [m_clabTest]!
}

class m_clabTest: Decodable
{
    var id : String!
    var name : String!
    
}
