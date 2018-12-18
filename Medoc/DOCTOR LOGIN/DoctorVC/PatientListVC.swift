

import UIKit
import Alamofire
import ZAlertView

class PatientListVC: UIViewController
{

   
    @IBOutlet var viewRefelID: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var tblPatientList: UITableView!
    
    @IBOutlet weak var txtPatProblems: UITextView!
    @IBOutlet weak var txtPatEmail: HoshiTextField!
    @IBOutlet weak var txtContactNo: HoshiTextField!
    @IBOutlet weak var txtPatNm: HoshiTextField!
    @IBOutlet var viewAddPatient: UIView!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    var m_cPatintInfoArr = [CPatientEntryData]()
    var popUp = KLCPopup()
    var Utype : String!
    var Uid : String!
    var formValid = Bool(true)
    var toast = JYToast()
     var showMenu = Bool(true)
    var alertwithtext = ZAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        SetReferalId()
        tblPatientList.separatorStyle = .none
     
        self.tblPatientList.delegate = self
        self.tblPatientList.dataSource = self
      
        self.tblPatientList.separatorStyle = .none
        self.tblPatientList.estimatedRowHeight = 80
        self.tblPatientList.rowHeight = UITableView.automaticDimension
    }
    
    func SetReferalId()
    {
       
        alertwithtext = ZAlertView(title: "Medoc", message: "Write a Referral Code here", isOkButtonLeft: false, okButtonText: "OK", cancelButtonText: "Not Now", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Remark")!
           
            print(txt1.text!)
           
           
        }) { (cancel) in
            cancel.dismissAlertView()
            ZAlertView.init(title: "Medoc", msg: "If you do not have any Referral code, please take it from your reference. You can connect to 'connect@ksoftpl.com'", actiontitle: "OK") {
                print("")
            }
        }
        alertwithtext.addTextField("Remark", placeHolder: "Write Referral Code")
       
        alertwithtext.show()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.TopView.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
        containerView.isHidden = true
      
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        txtPatProblems.text = nil
        txtPatProblems.textColor = UIColor.darkGray
    }
    
    @IBAction func btnInfo_onClick(_ sender: Any)
    {
        
    }
    @IBAction func btnOkRefel_onClick(_ sender: Any)
    {
        
    }
    
    @IBAction func btnNotNow_onClick(_ sender: Any)
    {
        
       
    }
    
    @IBAction func btnClosePopup_onClick(_ sender: Any)
    {
        popUp.dismiss(true)
    }
    
    func clearData()
    {
        txtPatNm.text = ""
        txtPatEmail.text = ""
        txtContactNo.text = ""
        txtPatProblems.text = "Write Here"
    }
    
    @IBAction func btnAddPatient_onClick(_ sender: Any)
    {
//        viewRefelID.isHidden = true
//        viewAddPatient.isHidden = false
        clearData()
        popUp.contentView = viewAddPatient
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    @IBAction func btnSavePatData_onClick(_ sender: Any)
    {
        
        if validation()
        {
            let lcPatientInfo = CPatientEntryData(pName: txtPatNm.text!, pContact: txtContactNo.text!, pEmail: txtPatEmail.text!, pProblems: txtPatProblems.text)
            self.m_cPatintInfoArr.append(lcPatientInfo)
            self.tblPatientList.reloadData()
            popUp.dismiss(true)
        }
    }
    
    func validation() -> Bool
    {
        if txtPatNm.text == ""
        {
           self.toast.isShow("Patient name in mandatory")
            return false
        }
        
        if ((txtContactNo.text?.count)! < 10) || ((txtContactNo.text?.count)! > 10)
        {
            self.toast.isShow("Please enter valid mobile number")
            return false
        }
        
        if txtPatProblems.text == ""
        {
            self.toast.isShow("Please write a patient problems")
            return false
        }
        
        return true
    }
    
    @IBAction func btnHome_onClick(_ sender: Any)
    {
        showMenu = !showMenu
        containerView.isHidden = showMenu
    }
    
    @IBAction func btnLogout_onClick(_ sender: Any)
    {
        ZAlertView(title: "Medoc", msg: "Are you sure you want to logout ?", dismisstitle: "No", actiontitle: "Yes")
        {
            print("yes")
        }

    }
    
}
extension PatientListVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.m_cPatintInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPatientList.dequeueReusableCell(withIdentifier: "PatientListCell", for: indexPath) as! PatientListCell
        
        cell.lblPName.text = self.m_cPatintInfoArr[indexPath.row].P_name
        cell.lblPproblems.text = self.m_cPatintInfoArr[indexPath.row].P_problems
        
         return cell
        
    }

}

