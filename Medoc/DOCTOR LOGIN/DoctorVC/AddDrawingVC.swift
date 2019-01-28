//
//  AddDrawingVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/19/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

protocol DrawingOnPadProtocol {
    func DrawingOnPad()
}

class DrawingArr : NSObject
{
    var drawing_img : UIImage!
    var drawing_tag : String!
    var drawing_timestamp : String!
    
    init(cDrawImg : UIImage, cDrawTag : String, cDrawTimestamp : String)
    {
        self.drawing_img = cDrawImg
        self.drawing_tag = cDrawTag
        self.drawing_timestamp = cDrawTimestamp
    }
}

class CDrawData
{
    var m_cDrawDataArr = [DrawingArr]()
}

class AddDrawingVC: UIViewController, PaintDocsDelegate
{
    
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btndrawing: UIButton!
    @IBOutlet weak var tbldrawing: UITableView!
    
    var m_cDrawingArr = [DrawingArr]()
    var m_d_DrawingOnpad : DrawingOnPadProtocol!
    var m_cDrawData: CDrawData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbldrawing.delegate = self
        tbldrawing.dataSource = self
        tbldrawing.separatorStyle = .none
        Btn(btn: [btnsave, btndrawing])
        
        if self.m_cDrawingArr.isEmpty == false
        {
            self.tbldrawing.reloadData()
        }
    }
    
    func Btn(btn : [UIButton])
    {
        for BTN in btn
        {
            BTN.layer.cornerRadius = 5
            BTN.layer.borderWidth = 1.5
            BTN.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func btnBack_OnClik(_ sender: Any)
    {
       
        let lcViewControllsArr = self.navigationController?.viewControllers
        lcViewControllsArr?.forEach({ (lcViewController) in
            if let lcAndroidVc = lcViewController as? AndriodPrescFormVC
            {
        self.navigationController?.popToViewController(lcAndroidVc, animated: true)
            }
            })
        
       
    }
    
    @IBAction func btnSave_onclick(_ sender: Any)
    {
        
        let lcViewControllsArr = self.navigationController?.viewControllers
        lcViewControllsArr?.forEach({ (lcViewController) in
            if let lcAndroidVc = lcViewController as? AndriodPrescFormVC
            {
                lcAndroidVc.DrawingOnPad()
                self.navigationController?.popToViewController(lcAndroidVc, animated: true)
            }
        })
    }
    
    @IBAction func btnDrawing_onclick(_ sender: Any)
    {
        let lcPrescriptionViewControllerVC = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        lcPrescriptionViewControllerVC.m_cPaintDocsdelegate = self
        lcPrescriptionViewControllerVC.m_bView = true
        lcPrescriptionViewControllerVC.m_cDrawData = self.m_cDrawData
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(lcPrescriptionViewControllerVC, animated: true)
    }
    
    func DrawingDocs(docImg: UIImage, doctag: String, doctimeStamp: String)
    {

        let lcdict = DrawingArr(cDrawImg: docImg, cDrawTag: doctag, cDrawTimestamp: doctimeStamp)
        self.m_cDrawingArr.append(lcdict)
        print(self.m_cDrawingArr)
        self.tbldrawing.reloadData()
    }
    
    func PaintDocs(docs: UIImage, docnm: String, docTimeStamp: String)
    {
      print("")
    }
    
}
extension AddDrawingVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.m_cDrawData.m_cDrawDataArr.count != 0
        {
            return self.m_cDrawData.m_cDrawDataArr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbldrawing.dequeueReusableCell(withIdentifier: "AddDrawingImgCell", for: indexPath) as! AddDrawingImgCell
        
        let lcdata = self.m_cDrawData.m_cDrawDataArr[indexPath.row]
        
        cell.imgDrawing.image = lcdata.drawing_img
        cell.lbl_imgTag.text = lcdata.drawing_tag
        
        cell.backview.designCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
}
