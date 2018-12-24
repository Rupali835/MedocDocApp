

import UIKit
import Alamofire
import ZAlertView

class PatientListVC: UIViewController, UITextViewDelegate
{

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
    
    var alertwithtext = ZAlertView()
    var PatientArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if UserDefaults.standard.value(forKey: "RefMsg") != nil
       {
            print("Referral code set")
       }else{
             SetReferalId()
        }
        
        tblPatientList.separatorStyle = .none
     
        self.tblPatientList.delegate = self
        self.tblPatientList.dataSource = self
      
        self.tblPatientList.separatorStyle = .none
        self.tblPatientList.estimatedRowHeight = 80
        self.tblPatientList.rowHeight = UITableView.automaticDimension
        
        self.txtPatProblems.delegate = self
        
        GetPatientData()
        
    }
    
    func SetReferalId()
    {
       self.formValid = false
        alertwithtext = ZAlertView(title: "Medoc", message: "Write a Referral Code here", isOkButtonLeft: false, okButtonText: "OK", cancelButtonText: "Not Now", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Remark")!
           
            let RefId = txt1.text!
            
            self.SendRefelCode(refId: RefId)
            send.dismissAlertView()
           
        }) { (cancel) in
            cancel.dismissAlertView()
            
            ZAlertView.init(title: "Medoc", msg: "If you do not have any Referral code, please take it from your reference. You can connect to 'connect@ksoftpl.com'", actiontitle: "OK") {
                print("")
            }
        }
        alertwithtext.addTextField("Remark", placeHolder: "Write Referral Code")
       
        alertwithtext.show()
    
        
    }
    
    func SendRefelCode(refId : String)
    {
        let refApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/update_ref_id"
        let param = ["loggedin_id" : "2",
                     "ref_id" : refId]
        
        Alamofire.request(refApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    UserDefaults.standard.set(Msg, forKey: "RefMsg")
                    self.toast.isShow("Your referral id is added")
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.TopView.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
        navigationController?.navigationBar.isHidden = true
        
      sideMenus()
    
    }
    
   
    
    func sideMenus()
    {
    
        revealViewController().navigationController?.navigationBar.isHidden = false
        if revealViewController() != nil {
            
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 500
            revealViewController().rightViewRevealWidth = 110
        }

    }
    
 
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        txtPatProblems.text = nil
        txtPatProblems.textColor = UIColor.darkGray
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
//            let lcPatientInfo = CPatientEntryData(pName: txtPatNm.text!, pContact: txtContactNo.text!, pEmail: txtPatEmail.text!, pProblems: txtPatProblems.text)
//            self.m_cPatintInfoArr.append(lcPatientInfo)
            
            
            TakePatientData()
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

    }
    
    @IBAction func btnLogout_onClick(_ sender: Any)
    {
        ZAlertView(title: "Medoc", msg: "Are you sure you want to logout ?", dismisstitle: "No", actiontitle: "Yes")
        {
            print("yes")
        }

    }
    
    func TakePatientData()
    {
        let PatApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/add_patient"
        
        let param = ["loggedin_id" : "2",
                     "loggedin_role" : "5",
                     "action" : "add",
                     "name" : txtPatNm.text!,
                     "gender" : "Male",
                     "email" : txtPatEmail.text!,
                     "contact" : txtContactNo.text!,
                     "description" : txtPatProblems.text!] as [String : Any]
  
        print(param)
        Alamofire.request(PatApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.toast.isShow("Added successfully")
                    self.GetPatientData()
                    self.popUp.dismiss(true)
                }
                
                break
            case .failure(_):
                self.toast.isShow("Something went wrong")
                self.popUp.dismiss(true)
                break
            }
        }
    
    }
    
    func GetPatientData()
    {
        let getPatApi = "http://www.otgmart.com/medoc/medoc_new/index.php/API/get_todays_patients"
        
        let param = ["loggedin_id" : "2",
                     "loggedin_role" : "5"]
        
        Alamofire.request(getPatApi, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let Msg = json["msg"] as! String
                if Msg == "success"
                {
                    self.PatientArr = json["data"] as! [AnyObject]
                    self.tblPatientList.reloadData()
                }else{
                    self.toast.isShow("No any patient")
                }
                
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
        }
    }
    
}
extension PatientListVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.PatientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPatientList.dequeueReusableCell(withIdentifier: "PatientListCell", for: indexPath) as! PatientListCell
        
        let lcdict = self.PatientArr[indexPath.row]
        
        cell.lblPName.text = lcdict["name"] as! String
        cell.lblPproblems.text = lcdict["p_description"] as! String
        
         return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PatientPrescriptionVC") as! PatientPrescriptionVC
        
        let lcdict = self.PatientArr[indexPath.row]
        vc.PatInfoArr = lcdict as! [String : Any]
        navigationController?.pushViewController(vc, animated: true)
    }

}

