

import UIKit
import Alamofire
import ZAlertView
import AVKit
import AVFoundation
import LiquidFloatingActionButton
import SkyFloatingLabelTextField


class AddPatient
{
    var loggedin_id : Int!
    var loggedin_role : String!
    var action : String!
    var name : String!
    var gender : String!
    var email : String!
    var contact : String!
    var appointment_date : String!
    var profile_picture : String!

}

class PatientListVC: UIViewController, AddPatientProtocol
{
   
   
    @IBOutlet weak var viewBtnPatinet: UIView!
    @IBOutlet weak var lineTotalPatient : UILabel!
    
    
    @IBOutlet weak var newsCollection: UICollectionView!
    @IBOutlet var viewExistingPatient: UIView!
    @IBOutlet weak var lineMonthlyPatient : UILabel!
    @IBOutlet weak var btnMonthlyPatient : UIButton!
    @IBOutlet weak var btnTotalPatient : UIButton!
    
   
    @IBOutlet weak var HgtofViewofCollection: NSLayoutConstraint!
 
    @IBOutlet weak var collPatientList: UICollectionView!
    @IBOutlet weak var TopView: UIView!
  
    @IBOutlet var viewAddPatient: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var lblRepeted_patient_count: UILabel!
    @IBOutlet weak var lblTotal_patient_count: UILabel!
    @IBOutlet weak var lblExisting_patient_count: UILabel!
    @IBOutlet weak var lblNew_patient_count: UILabel!
    
    var m_cPatintInfoArr = [CPatientEntryData]()
    var popUp = KLCPopup()
    var Utype : String!
    var Uid : String!
    var formValid = Bool(true)
    var toast = JYToast()
    
    var alertwithtext = ZAlertView()
    var PatientArr = [AnyObject]()
    
    var sidevc : SideMenuListVC!
    var m_cAddPatient = AddPatient()

   
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    var m_bStatus = Bool(true)
    var CountArr = [AnyObject]()
    
    var addPatientVc : AddPatientVC!
    var newsArr = [AnyObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCountLines()
        getHealthData()
        self.m_bStatus  = true
        self.viewBtnPatinet.isHidden = true
        
        if UserDefaults.standard.value(forKey: "RefMsg") != nil
       {
            print("Referral code set")
       }else{
            
             SetReferalId()
        }
    
      let dict = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
       
        m_cAddPatient.loggedin_id = dict["id"] as? Int
        m_cAddPatient.loggedin_role = dict["role_id"] as? String
       
        GetPatientData()
        collPatientList.delegate = self
        collPatientList.dataSource = self
        newsCollection.delegate = self
        newsCollection.dataSource = self
        self.GetCount()
    }
    
    override func awakeFromNib() {
        self.addPatientVc = (AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AddPatientVC") as! AddPatientVC)
    }
    
    func callAddPatientApi() {
        GetPatientData()
    }
    
    
    func sideMenus()
    {
       
        if revealViewController() != nil {
            
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
        }
    }

    func getHealthData()
    {
        let NewsApi = "https://newsapi.org/v2/top-headlines?category=health&country=in&apiKey=c5b24a8c983d4480b5197c75fe2a0308"
        
        Alamofire.request(NewsApi, method: .get, parameters: nil).responseJSON { (resp) in
           
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
              self.newsArr = json["articles"] as! [AnyObject]
                
                self.newsCollection.reloadData()
                break
                
            case .failure(_):
                break
            }
        }
        
    }
    
    
    @IBAction func btnScanQR_onclick(_ sender: Any)
    {
        popUp.dismiss(true)
        let scanvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "ScannerVC") as! ScannerVC
        self.navigationController?.pushViewController(scanvc, animated: true)
    }
    
    @IBAction func btncloseExistingPatView_onclick(_ sender: Any)
    {
        self.popUp.dismiss(true)
    }
    
    func GetCount()
    {
        let countApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_counts"
        
        let Parm = ["loggedin_id" : m_cAddPatient.loggedin_id!,
                    "loggedin_role" : m_cAddPatient.loggedin_role!] as [String : Any]
        
        Alamofire.request(countApi, method: .post, parameters: Parm).responseJSON { (resp) in
           
            switch resp.result
            {
            case .success(_):
               let json = resp.result.value as! NSDictionary
               
               let Msg = json["msg"] as! String
               if Msg == "success"
               {
                self.CountArr = json["data"] as! [AnyObject]
                
                for lcdata in self.CountArr
                {
                    self.lblTotal_patient_count.text = String(lcdata["ptt_total"] as! Int)
                    self.lblNew_patient_count.text = String(lcdata["ptt_new"] as! Int)
                    self.lblExisting_patient_count.text = String(lcdata["ptt_existing"] as! Int)
                    self.lblRepeted_patient_count.text = String(lcdata["ptt_repeated"] as! Int)
                }
                
               }
               
                break
                
            case .failure(_):
                break
                
                
            }
        }
    }
    
    
    @IBAction func btnPlusforpatient_onclick(_ sender: Any)
    {
        self.m_bStatus = !self.m_bStatus
       SetButtonStatus(bStatus: m_bStatus)
        
    }
    
    func SetButtonStatus(bStatus: Bool)
    {
        UIView.transition(with: self.viewBtnPatinet,
                          duration: 0.5,
                          options: [.transitionFlipFromTop],
                          animations: {
                            self.viewBtnPatinet.isHidden = bStatus
                            
        },
                          completion: nil)
    }
    
    
    @IBAction func btnNewPatient_onclick(_ sender: Any)
    {
       
        
        UIView.animate(withDuration: 0.5)
        {
            self.viewBtnPatinet.isHidden = true
            self.addPatientVc.view.frame = self.view.frame
            self.addPatientVc.m_dAddPatient = self
            self.view.addSubview(self.addPatientVc.view)
            self.addPatientVc.view.clipsToBounds = true
        }
    }
    
    @IBAction func btnExistingPatient_onclick(_ sender: Any)
    {
        self.viewBtnPatinet.isHidden = true
        self.m_bStatus = true
        SetButtonStatus(bStatus: self.m_bStatus)
        popUp.contentView = viewExistingPatient
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }

    func SetReferalId()
    {
    
        UIView.animate(withDuration: 2.0) {
            
            ZAlertView.showAnimation = .fadeIn
            
            self.formValid = false
            self.alertwithtext = ZAlertView(title: "Medoc", message: "Write a Referral Code here", isOkButtonLeft: false, okButtonText: "OK", cancelButtonText: "Not Now", okButtonHandler: { (send) in
                
                let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Remark")!
                
                let RefId = txt1.text!
                
                self.SendRefelCode(refId: RefId)
   //             send.dismissAlertView()
                send.dismissWithDuration(0.5)
                ZAlertView.hideAnimation = .fadeOut
                
            }) { (cancel) in
   //         cancel.dismissAlertView()
                cancel.dismissWithDuration(0.5)
                
                
                
                ZAlertView.init(title: "Medoc", msg: "If you do not have any Referral code, please take it from your reference. You can connect to 'connect@ksoftpl.com'", actiontitle: "OK") {
                    print("")
                }
            }
            self.alertwithtext.addTextField("Remark", placeHolder: "Write Referral Code")
            
          //  self.alertwithtext.show()
            self.alertwithtext.showWithDuration(1.0)
            
        }
        
    }
    
    func SendRefelCode(refId : String)
    {
        let refApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/update_ref_id"
        let param = ["loggedin_id" : m_cAddPatient.loggedin_id!,
                     "ref_id" : refId] as [String : Any]
        
        Alamofire.request(refApi, method: .post, parameters: param).responseJSON { (resp) in
            
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
    revealViewController().navigationController?.navigationBar.isHidden = true
      self.sideMenus()
    }
 
  
    func GetPatientData()
    {
        let getPatApi = "http://www.otgmart.com/medoc/medoc_doctor_api/index.php/API/get_todays_patients"
        
        let param = ["loggedin_id" : m_cAddPatient.loggedin_id!,
                     "loggedin_role" : m_cAddPatient.loggedin_role!] as [String : Any]
        
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
                   self.collPatientList.reloadData()
                    
                    if self.PatientArr.count == 2
                    {
                        self.HgtofViewofCollection.constant = 120
                    }
                    if self.PatientArr.count == 3
                    {
                        self.HgtofViewofCollection.constant = 240
                    }
                    if self.PatientArr.count == 4
                    {
                        self.HgtofViewofCollection.constant = 240
                    }
                    if self.PatientArr.count > 4
                    {
                        self.HgtofViewofCollection.constant = 240
                    }
                    
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

   
    private func playVideo()
    {
        guard let path = Bundle.main.path(forResource: "Phlebotomy- Syringe Draw Procedure - Blood Collection (Rx-TN)", ofType:"mp4")
            else {
            debugPrint("video.m4v not found")
            return
        }

        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }

   }
    
    @IBAction func btnPlayVideo_onclick(_ sender: Any)
    {
        playVideo()
    }
   
    func setCountLines()
    {
        self.btnTotalPatient.setTitleColor(UIColor(red:0.18, green:0.66, blue:0.29, alpha:1.0), for: .normal)
        
        self.btnMonthlyPatient.setTitleColor(UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0), for: .normal)
        
        self.lineTotalPatient.backgroundColor = UIColor(red:0.18, green:0.66, blue:0.29, alpha:1.0)
        
        self.lineMonthlyPatient.backgroundColor = UIColor.clear
    }
    
    
    @IBAction func btnPatient_till_today_onclick(_ sender: Any)
    {
       setCountLines()
        
        let CountData = self.CountArr
        
        for lcdata in CountData
        {
           lblTotal_patient_count.text = String(lcdata["ptt_total"] as! Int)
            lblNew_patient_count.text = String(lcdata["ptt_new"] as! Int)
            lblExisting_patient_count.text = String(lcdata["ptt_existing"] as! Int)
            lblRepeted_patient_count.text = String(lcdata["ptt_repeated"] as! Int)
        }
    
    }
    
    
    @IBAction func btnMonthly_patient_onclick(_ sender: Any)
    {
        self.btnMonthlyPatient.setTitleColor(UIColor(red:0.18, green:0.66, blue:0.29, alpha:1.0), for: .normal)
        
        self.btnTotalPatient.setTitleColor(UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0), for: .normal)
        
        self.lineMonthlyPatient.backgroundColor = UIColor(red:0.18, green:0.66, blue:0.29, alpha:1.0)
        
        self.lineTotalPatient.backgroundColor = UIColor.clear
        
        
        
        let CountData = self.CountArr
        
        for lcdata in CountData
        {
            lblTotal_patient_count.text = String(lcdata["m_total"] as! Int)
            lblNew_patient_count.text = String(lcdata["m_new"] as! Int)
            lblExisting_patient_count.text = String(lcdata["m_existing"] as! Int)
           lblRepeted_patient_count.text = String(lcdata["m_repeated"] as! Int)
            
        }

    }
    
    @objc func openUrlOnWeb(sender: UIButton)
    {
        let newsweb = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "newsFeedWebViewVC") as! newsFeedWebViewVC
       
        let nIndex = sender.tag
        
        let lcdict = self.newsArr[nIndex]

          if let Url = lcdict["url"] as? String
            {
                newsweb.urlStr = Url
            }
            self.navigationController?.pushViewController(newsweb, animated: true)

    }
    
    
}
extension PatientListVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collPatientList
        {
             return self.PatientArr.count
        }else if collectionView == newsCollection
        {
            return self.newsArr.count
        }else
        {
            return 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collPatientList
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PatientListCollectionCell", for: indexPath) as! PatientListCollectionCell
            let lcdict = self.PatientArr[indexPath.row]
            let index = indexPath.row
            cell.lblNum.text = String(index + 1)
            cell.lblPatNm.text = lcdict["name"] as? String
            
            cell.backview.designCell()
            return cell
        }
        else if collectionView == newsCollection
        {
            let Ncell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsFeedHomePageCell", for: indexPath) as! NewsFeedHomePageCell
           let lcdict = self.newsArr[indexPath.row]
           
            if let Title = lcdict["title"] as? String
            {
                Ncell.newslbl.text = Title
            }else{
                Ncell.newslbl.text = ""
            }
            
            if let Img = lcdict["urlToImage"] as? String
            {
                let imgUrl = URL(string: Img)
                
                Ncell.newsimg.kf.setImage(with: imgUrl)
            }else{
                Ncell.newsimg.image = UIImage(named : "MedocAppIcon")
            }
            
            Ncell.backview.designCell()
            Ncell.backview.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)
            Ncell.btnReadMore.layer.borderColor = UIColor.darkGray.cgColor
            Ncell.btnReadMore.layer.borderWidth = 1
            
            
            Ncell.btnReadMore.tag = indexPath.row
            Ncell.btnReadMore.addTarget(self, action: #selector(openUrlOnWeb(sender:)), for: .touchUpInside)
            
            Ncell.btnTapAction = {
                () in
                print("Edit tapped in cell", indexPath)
                // start your edit process here...
            }

            return Ncell
        }else
        {
            return UICollectionViewCell()
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collPatientList
        {
            let prescvc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PatientPrescriptionListVC") as! PatientPrescriptionListVC
            let lcdict = self.PatientArr[indexPath.row]
            
            UserDefaults.standard.set(lcdict, forKey: "PatientDict")
            
            prescvc.PatientDict = lcdict as! [String : Any]
            
            self.navigationController?.pushViewController(prescvc, animated: true)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.collPatientList.frame.size.width) / 2, height: 120)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}

extension String
{
    var isValidIndianContact: Bool {
        let phoneNumberRegex = "^[7-9][0-9]{8,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }

}


