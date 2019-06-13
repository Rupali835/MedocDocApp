//
//  HospitalListVc.swift
//  Medoc
//
//  Created by Rupali Patil on 12/06/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class HospitalListVc: UIViewController {

    @IBOutlet weak var collHospital: UICollectionView!
    
    @IBOutlet weak var btnback: UIButton!
    var h_listArr = [getHospitalList]()
    var img_path = "http://medoc.co.in/medoc_doctor_api/uploads/"
    var Lid : Int!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        collHospital.delegate = self
        collHospital.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        self.Lid = dict["id"] as? Int
        getHospital(id: Lid!)
    }
    
    @IBAction func btnAddClinic_onclick(_ sender: Any)
    {
        let VC1 = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "AddClinicVC") as! AddClinicVC
        VC1.delegate = self
        self.present(VC1, animated:true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.sideMenus()
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func getHospital(id : Int)
    {
        let Api = Constant.BaseUrl + Constant.getClinic
        let param = ["loggedin_id" : id]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                do{
                    
                    let json = try JSONDecoder().decode(HospitalData.self, from: resp.data!)
                    
                    if json.msg == "success"
                    {
                        self.h_listArr = json.hospital
                        self.collHospital.reloadData()
                    }
                    if json.msg == "fail"
                    {
                      Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "Please add your primary hospital or clinic")
                    }
                    
                }catch{
                    Alert.shared.basicalert(vc: self, title: "MeDoc", msg: "\(error.localizedDescription)")
                }
                break
                
            case .failure(_):
                break
                
            }
            
        }
    }
}
extension HospitalListVc : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return h_listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collHospital.dequeueReusableCell(withReuseIdentifier: "getHospitalCell", for: indexPath) as! getHospitalCell
        
        let lcdict = h_listArr[indexPath.item]
        cell.lblClinicNm.text = lcdict.name
        
        if lcdict.email != ""
        {
            cell.lblClinicEmail.text = lcdict.email
        }else{
            cell.lblClinicEmail.text = "not provided"
        }
        
        cell.lblClinicNumber.text = lcdict.contact
        if lcdict.logo != "NF" && lcdict.logo != ""
        {
            let str = "\(self.img_path)\(lcdict.logo!)"
            let imgUrl = URL(string: str)
            cell.imgClinicLogo.kf.setImage(with: imgUrl)
        }else
        {
            cell.imgClinicLogo.image = UIImage(named: "MedocAppIcon")
        }
        
        return cell
    }
}
extension HospitalListVc : AddClinicProtocol
{
    func addClinicInprofile() {
        self.getHospital(id: self.Lid)
    }
}

