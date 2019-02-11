//
//  AddReportVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/11/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import ZAlertView

protocol reportImgDelegate {
    func reportImages()
}


class CReportData {
    var m_cReportDataArr = [ReportImageArr]()
}
class ReportImageArr
{
    var Report_img: UIImage!
    var Report_timestamp: String!
    var Report_Tag: String!
    
    init(cReport_img : UIImage, cReport_timestmp : String, cReport_tag : String)

    {
        self.Report_img = cReport_img
        self.Report_timestamp = cReport_timestmp
        self.Report_Tag = cReport_tag
    }
}


class AddReportVC: UIViewController
{
   
    @IBOutlet weak var btnAddReport: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var tblReportData: UITableView!
    
    @IBOutlet weak var m_cImageName: UILabel!
    var selectedImage: UIImage!
    var DocumentselectedImage: UIImage!
    var filePath: String!
    var fileURL: URL!
    var fileName: String!
    var DocumentImageFileName: String!
    var DocumentFileURL: URL!
    var DocumentFileName: String?
    var m_cReportDelegate : reportImgDelegate!
    var alert = ZAlertView()
  //  var m_cReportImgArr = [ReportImageArr]()
    
    var m_cReportData: CReportData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if m_cReportData.m_cReportDataArr.isEmpty == false
        {
            tblReportData.reloadData()
        }
        
        Btn(btn: btnsave)
        Btn(btn: btnAddReport)
        
        tblReportData.delegate = self
        tblReportData.dataSource = self
        tblReportData.separatorStyle = .none
    }
    
    func Btn(btn : UIButton)
    {
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddReport_onclick(_ sender: Any)
    {
        self.TakePhoto()
    }
    
    @IBAction func btnSave_onClick(_ sender: Any)
    {
        m_cReportDelegate.reportImages()
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func Delete_Click(sender: AnyObject)
    {
        
        ZAlertView(title: "Medoc", msg: "Are you sure you want to delete this ?", dismisstitle: "No", actiontitle: "Yes")
        {
            let nIndex = sender.tag
            let refArrObj = self.m_cReportData.m_cReportDataArr[nIndex!]
            self.m_cReportData.m_cReportDataArr.remove(at: nIndex!)
            self.tblReportData.reloadData()
        }
        
    }
    
    func TakePhoto()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            for lcAttachment in CDBAttachmentArr
            {
                self.fileName = lcAttachment.fileName
               if lcAttachment.fileName == nil
               {
                 self.fileName = "ReportImage"
                }
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
                    let timestamp = Date().toMillis()
                    image?.accessibilityIdentifier = String(describing: timestamp)
                    
                    let lcReport = ReportImageArr(cReport_img: image!, cReport_timestmp: String(describing: timestamp!), cReport_tag: self.fileName!)
                    
                 self.m_cReportData.m_cReportDataArr.append(lcReport)
                   
                    self.tblReportData.reloadData()
                    
                })
                
            }
            
        }, cancel: nil)
        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.capturedVideoQulity = UIImagePickerController.QualityType.typeHigh
        attachmentPickerController.allowsMultipleSelection = false
        attachmentPickerController.allowsSelectionFromOtherApps = false
        attachmentPickerController.present(on: self)
    }
    
}
extension AddReportVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.m_cReportData.m_cReportDataArr.isEmpty == false
        {
            return self.m_cReportData.m_cReportDataArr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblReportData.dequeueReusableCell(withIdentifier: "AddReportImgCell", for: indexPath) as! AddReportImgCell
        
        cell.backview.designCell()
        
        let lcdict =  self.m_cReportData.m_cReportDataArr[indexPath.row]
        cell.imgReport.image = lcdict.Report_img
        
        cell.imgReport.contentMode = UIView.ContentMode.scaleAspectFit
        cell.imgReport.clipsToBounds = true
        cell.m_cNamelbl.text = lcdict.Report_Tag
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
}
