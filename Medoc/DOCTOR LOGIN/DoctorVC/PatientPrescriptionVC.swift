

import UIKit
import DropDown


class PatientPrescriptionVC: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var txtOtherDetail: UITextView!
    @IBOutlet weak var tblviewHeight: NSLayoutConstraint!
    @IBOutlet weak var medicalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtThirdMedicinetime: UITextField!
    @IBOutlet weak var txtSecMedicineTime: UITextField!
    @IBOutlet weak var btnSetMedicalData: UIButton!
    @IBOutlet weak var txtEnterMedicalTime: UITextField!
    @IBOutlet weak var txtEnterMedicalNm: UITextField!
    @IBOutlet weak var tblMedical: UITableView!
    @IBOutlet weak var txtWritePrescription: UITextView!
    @IBOutlet weak var lblReferdBy: UILabel!
    @IBOutlet weak var lblPatId: UILabel!
    @IBOutlet weak var lblPatNm: UILabel!
    @IBOutlet weak var viewPid: UIView!
    @IBOutlet weak var btnAddPrescription: UIButton!
    
    var PatInfoArr = [String : Any]()
    var m_cMedicineData = [cMedicianEntryData]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.txtWritePrescription.delegate = self
        self.txtOtherDetail.delegate = self
        
        let Nm = self.PatInfoArr["name"] as! String
        let PatId = self.PatInfoArr["patient_id"] as! String
        
        lblPatNm.text = "Name : \(Nm)"
        lblPatId.text = "Patient ID : \(PatId)"
        
        tblviewHeight.constant = 0
        medicalViewHeight.constant = 140
        
        tblMedical.delegate = self
        tblMedical.dataSource = self
        tblMedical.separatorStyle = .none
        
        txtEnterMedicalNm.clearButtonMode = .always
        txtEnterMedicalTime.clearButtonMode = .always
        txtSecMedicineTime.clearButtonMode = .always
        txtThirdMedicinetime.clearButtonMode = .always
        
        setBtnView()
    

        
    }
    
    func setBtnView()
    {
        btnsave.layer.borderColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0).cgColor
        btnsave.layer.borderWidth = 1.0
        btnsave.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnsave.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnsave.layer.shadowOpacity = 1.0
        btnsave.layer.shadowRadius = 0.0
        btnsave.layer.masksToBounds = false
        btnsave.layer.cornerRadius = 30.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView == self.txtWritePrescription{
            if self.txtWritePrescription.text == "Write Here.."
            {
                self.txtWritePrescription.text = ""
            }
        }
        
        if textView == self.txtOtherDetail
        {
            if self.txtOtherDetail.text == "Write Here.."
            {
                self.txtOtherDetail.text = ""
            }
        }
    }
    
    
    
    @IBAction func btnSetMedicalData_onClick(_ sender: Any)
    {
        let lcdata = cMedicianEntryData(cMedicinenm: txtEnterMedicalNm.text!, cMedicinetime: txtEnterMedicalTime.text!, cSec: txtSecMedicineTime.text!, cThird: txtThirdMedicinetime.text!)
        
        self.m_cMedicineData.append(lcdata)
        tblMedical.reloadData()
        
        let ArrCount = self.m_cMedicineData.count
        
        tblviewHeight.constant = CGFloat(80 * ArrCount)
        
        let viewHgt = Int(tblviewHeight.constant)
        
        medicalViewHeight.constant = CGFloat(150 + viewHgt)
        
        
      }
    
    
    @IBAction func btnAddPrescription_onClick(_ sender: Any)
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        present(vc, animated: true, completion: nil)
      
    }
    
    @objc func DeleteMedicineData(sender : UIButton)
    {
        let index = sender.tag
        print(index)
        self.m_cMedicineData.remove(at: index)
        tblMedical.reloadData()
        
        let ArrCount = self.m_cMedicineData.count
        
    }
    
    
    @IBAction func btnCloseForm_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension PatientPrescriptionVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblMedical.dequeueReusableCell(withIdentifier: "MedicalDetailCell", for: indexPath) as! MedicalDetailCell
        
        let lcdict = m_cMedicineData[indexPath.row]
        
        cell.lblMedicalNm.text = lcdict.medicineNm
        cell.lblMedicalTime.text = lcdict.medicineTime
        cell.lblSecondTime.text = lcdict.secMedicineTime
        cell.lblThirdTime.text = lcdict.ThirdMedicineTime
        
        
        cell.btnCancelMedicine.tag = indexPath.row
        cell.btnCancelMedicine.addTarget(self, action: #selector(DeleteMedicineData(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_cMedicineData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    
}
