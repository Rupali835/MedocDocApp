//
//  FetchResponseApi.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/20/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
import Alamofire

class FetchResponseApi: NSObject
{
    var toast = JYToast()
    var labTestArr = [AnyObject]()
    var m_cFetchRespApi = FetchResponseApi()
    
    func getMedicinedata()
    {
        let medicine_api = Constant.BaseUrl+Constant.getMedicineData
        
        Alamofire.request(medicine_api, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    let medicineArr = json["data"] as AnyObject
                }
                break
                
            case .failure(_):
                break
            }
            
        }
        
    }
    
    func getLabTest()
    {
        let labApi = Constant.BaseUrl+Constant.getLabtest
        
        Alamofire.request(labApi, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["success"] as! String
                if Msg == "success"
                {
                    self.labTestArr = json["data"] as! [AnyObject]
                }else
                {
                    self.labTestArr = []
                }
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
}
