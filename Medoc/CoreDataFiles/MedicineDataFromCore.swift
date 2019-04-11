//
//  MedicineData.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/20/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import Foundation
import Alamofire

class MedicineDataFromCore : NSObject
{
    var mainArr: [AnyObject]! = [AnyObject]()
    
    static let cMedicineData = MedicineDataFromCore()
    
    func getMedicineList()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let userUrl = Constant.BaseUrl + Constant.getMedicineData
       
        Alamofire.request(userUrl, method: .get, parameters: nil).responseJSON { (medData) in
            
            print(medData)
            
            switch medData.result
            {
            case .success(_):
                
                let Json = medData.result.value as! NSDictionary
                
                let Msg = Json["msg"] as! String
                if Msg == "success"
                {
                     self.mainArr = Json["data"] as? [AnyObject]
                    
                    self.deleteMedicineData()

                    for lcdata in self.mainArr
                    {
                        
                        let medicineEntity = FetchMedicineData(context: context)
                        
                        medicineEntity.author = lcdata["author"] as? String
                        medicineEntity.created_at = lcdata["created_at"] as?String
                        medicineEntity.created_by = lcdata["created_by"] as? String
                        medicineEntity.id = lcdata["id"] as? String
                        medicineEntity.medicine_name = lcdata["medicine_name"] as? String
                        medicineEntity.product_code = lcdata["product_code"] as? String
                        medicineEntity.rxstring = lcdata["rxstring"] as? String
                        medicineEntity.spl_inactive_ing = lcdata["spl_inactive_ing"] as? String
                        medicineEntity.spl_ingredients = lcdata["spl_ingredients"] as? String
                        medicineEntity.spl_strength = lcdata["spl_strength"] as? String
                        medicineEntity.splcolor_text = lcdata["splcolor_text"] as? String
                        medicineEntity.splshape_text = lcdata["splshape_text"] as? String
                        
                        appDel.saveContext()
                        
                    }
                    
                    
                }else{
                    self.mainArr = []
                }
                
                break
                
            case .failure(_):
                break
            }
            
        }
    }
    
    func fetchOfflineMedicineList() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchMedicineData.fetchRequest()) as [FetchMedicineData]
           
            
        }catch{
            
        }
        return nil
    }
   
//    func FeatchProjectsDataOffline() -> [AnyObject]?
//    {
//        let appDel = UIApplication.shared.delegate as! AppDelegate
//        let context = appDel.persistentContainer.viewContext
//        do{
//            let DataArr = try context.fetch(FeatchProjects.fetchRequest()) as [FeatchProjects]
//
//            return DataArr
//        }
//        catch{
//
//        }
//        return nil
//    }
//
    
    func deleteMedicineData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchMedicineData.fetchRequest()) as [FetchMedicineData]
            
            for (index, _) in DataArr.enumerated()
            {
                let UserEntity = DataArr[index]
                contx.delete(UserEntity)
            }
        }catch{
            
        }
    }
    
}
