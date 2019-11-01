//
//  AddPrescriptionDrawingVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/11/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import ZAlertView


protocol drawingOnBack {
    func sendDataToFirstPage()
}

class CPressData {
    var m_cPressDataArr = [PresArr]()
}

class PresArr : NSObject
{
    var PresImg : UIImage!
    var PresTimestampNm : String!
    
    init(cPressImg : UIImage, cTimestamp : String) {
        self.PresImg = cPressImg
        self.PresTimestampNm = cTimestamp
    }
}

class AddPrescriptionDrawingVC: UIViewController, PaintDocsDelegate {
   
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnAddPrescImg: UIButton!
    @IBOutlet weak var tblPaintImgs: UITableView!
    
    var m_cDrawimg : drawingOnBack!
   // var m_cPrescArr = [PresArr]()
    
    var m_cPressData : CPressData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblPaintImgs.separatorStyle = .none
        tblPaintImgs.delegate = self
        tblPaintImgs.dataSource = self
        
        Btn(btn: btnSave)
        Btn(btn: btnAddPrescImg)
    
       if self.m_cPressData.m_cPressDataArr != nil
        {
            self.tblPaintImgs.reloadData()
        }
    }
    
    func Btn(btn : UIButton)
    {
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
    }
    
    func showDataFromBack(cPrescArr: [PresArr])
    {
//        let lcdict = PresArr(cPressImg: docs, cNm: docnm, cTimestamp: docTimeStamp)
//        self.m_cPrescArr.append(lcdict)
        //self.m_cPrescArr.append(contentsOf: cPrescArr)
        self.m_cPressData.m_cPressDataArr.append(contentsOf: cPrescArr)
        
    }
    
    func PaintDocs(docs: UIImage, docnm: String, docTimeStamp: String)
    {
        let lcdict = PresArr(cPressImg: docs,cTimestamp: docTimeStamp)
        //self.m_cPrescArr.append(lcdict)
        self.m_cPressData.m_cPressDataArr.append(lcdict)
        self.tblPaintImgs.reloadData()
        
    }

    func DrawingDocs(docImg: UIImage, doctag: String, doctimeStamp: String)
    {
        print("")
    }
    
  @IBAction func btnAddPresImg_onclick(_ sender: Any)
    {
        var appstory = AppStoryboard.Doctor
        if UIDevice.current.userInterfaceIdiom == .pad {
            appstory = AppStoryboard.Doctor
        } else {
            appstory = AppStoryboard.IphoneDoctor
        }
        let lcPrescriptionVC = appstory.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        lcPrescriptionVC.m_cPaintDocsdelegate = self
         lcPrescriptionVC.m_cPressData = self.m_cPressData
        self.navigationController?.pushViewController(lcPrescriptionVC, animated: true)
        
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveImg_onclick(_ sender: Any)
    {
        
        let viewcontrollers = self.navigationController?.viewControllers
    
        //m_cDrawimg.sendDataToFirstPage()
        viewcontrollers?.forEach({ (vc) in
            if  let androidVC = vc as? AndriodPrescFormVC {
                androidVC.sendDataToFirstPage(); self.navigationController!.popToViewController(androidVC, animated: true)
            }
        })
        
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        
        let viewcontrollers = self.navigationController?.viewControllers
        
        viewcontrollers?.forEach({ (vc) in
            if  let androidVC = vc as? AndriodPrescFormVC {
                self.navigationController!.popToViewController(androidVC, animated: true)
            }
        })
        
    }
    
    @objc func Delete_Click(sender: AnyObject)
    {
        
        ZAlertView(title: "Medoc", msg: "Are you sure you want to delete this ?", dismisstitle: "No", actiontitle: "Yes")
        {
            let nIndex = sender.tag
            let refArrObj = self.m_cPressData.m_cPressDataArr[nIndex!]//
            self.m_cPressData.m_cPressDataArr.remove(at: nIndex!)
            self.tblPaintImgs.reloadData()
        }
    
    }
    
}
extension AddPrescriptionDrawingVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.m_cPressData.m_cPressDataArr.count != 0
        {
            return self.m_cPressData.m_cPressDataArr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblPaintImgs.dequeueReusableCell(withIdentifier: "AddPresImgCell", for: indexPath) as! AddPresImgCell
        cell.backview.designCell()
        
        let lcdata = self.m_cPressData.m_cPressDataArr[indexPath.item]//self.m_cPrescArr[indexPath.row]
        
        let index = indexPath.row + 1
        
        cell.imgPres.image = lcdata.PresImg
        cell.lblimgNm.text = "Page \(index)"
        
        cell.btnDeleteImg.tag = indexPath.row
        cell.btnDeleteImg.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
}
extension UserDefaults {
    func imageArray(forKey key: String) -> [UIImage]? {
        guard let array = self.array(forKey: key) as? [Data] else {
            return nil
        }
        return array.flatMap() { UIImage(data: $0) }
    }
    
    func set(_ imageArray: [UIImage], forKey key: String) {
        self.set(imageArray.flatMap({ $0.pngData() }), forKey: key)
    }
}
