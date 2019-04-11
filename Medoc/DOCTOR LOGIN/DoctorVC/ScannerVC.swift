//
//  ScannerVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/22/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import AVScanner
import AVFoundation
import ZAlertView
import CryptoSwift
import Alamofire

class ScannerVC: AVScannerViewController
{

    var hex = ""
    var toast = JYToast()
    var loginID = Int()
    var Key = "GFyb1eIRzR6zqWJjY97L+A==:QjJ/cH+l6nEoXn+dqf2Djnec/y+/s/Lua6xq1dLrjMk="
    
    let cryptLib = CryptLib()
    var m_dPatient : AddPatientProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareBarcodeHandler()
        prepareViewTapHandler()
        supportedMetadataObjectTypes = [.qr, .pdf417]
        
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        
        self.loginID = (dict["id"] as? Int)!
        
    
    }
    
    // MARK: - Prepare viewDidLoad
    
    private func prepareBarcodeHandler () {
        barcodeHandler = barcodeDidCaptured
    }
    
    private func prepareViewTapHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func viewTapHandler(_ gesture: UITapGestureRecognizer)
    {
        guard !isSessionRunning else { return }
        startRunningSession()
    }
    
    
    // Be careful with retain cycle
    lazy var barcodeDidCaptured: (_ codeObject: AVMetadataMachineReadableCodeObject) -> Void = { [unowned self] codeObject in
        let string = codeObject.stringValue!
        print(string)
        
        let decryptedString = self.cryptLib.decryptCipherTextRandomIV(withCipherText: string, key: self.Key)

            print("decryptedString \(decryptedString! as String)")

            if decryptedString != nil
            {
                self.TakePatientData(patId: decryptedString!)
            }
       
//        do{
//            let decryptedString = try self.cryptLib.decryptCipherTextRandomIV(withCipherText: string, key: self.Key)
//
//            if decryptedString != nil
//            {
//            self.TakePatientData(patId: decryptedString!)
//            }
//
//        }
//        catch let error {
//            print("Error: \(error)")
//        }
  
        
     
        
    }
    
    func TakePatientData(patId : String)
    {
        
       // let PatApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/add_patient"
        
        let PatApi = Constant.BaseUrl+Constant.addPatient
        
        let param = ["loggedin_id" : self.loginID,
                     "patient_id_existing" : patId,
                     "action" : "existing"
                     ] as [String : Any]
        
        print(param)
        Alamofire.request(PatApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                
                let Msg = json["msg"] as! String
                
                if Msg == "Patient Not Found"
                {
                    ZAlertView.init(title: "Medoc", msg: "Patient not found", actiontitle: "OK")
                    {
                        self.navigationController?.popViewController(animated: true)

                    }
                }
                if Msg == "success"
                {
                    self.toast.isShow("Existing patient is added")
                    let patientList = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "PatientListVC") as! PatientListVC
                    self.m_dPatient.callAddPatientApi()
                   self.navigationController?.popViewController(animated: true)
                }
                
                if Msg == "Patient has already been added"
                {
                    ZAlertView.init(title: "Medoc", msg: "Patient has already been added", actiontitle: "OK")
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                if Msg == "fail"
                {
                    ZAlertView.init(title: "Medoc", msg: "something went wrong", actiontitle: "Rescan")
                    {
            self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    


    @IBAction func btnBACk_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
}
