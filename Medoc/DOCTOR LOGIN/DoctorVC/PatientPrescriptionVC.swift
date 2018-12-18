

import UIKit
import DropDown


class PatientPrescriptionVC: UIViewController {

    @IBOutlet weak var btnDrawPrescription: UIButton!
    @IBOutlet weak var btnInchA: UIButton!
    @IBOutlet weak var btnFeetA: UIButton!
    @IBOutlet weak var txtTemp: UITextField!
    @IBOutlet weak var btnHgtInch: UIButton!
    @IBOutlet weak var btnHgtFt: UIButton!
    @IBOutlet weak var viewPrisptn: UIView!
    @IBOutlet weak var viewPid: UIView!
    @IBOutlet weak var btnBloodGrp: UIButton!
    @IBOutlet weak var btnTemp: UIButton!
    @IBOutlet weak var txtBloodGrp: UITextField!
    
    let dropdownBloodGrp = DropDown()
    let dropdownTemp = DropDown()
    let dropdownFt = DropDown()
    let dropdownInch = DropDown()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDropDown()
        btnAction()
       
        viewPid.designCell()
        viewPrisptn.designCell()
    }
    
    func btnAction()
    {
        btnBloodGrp.addTarget(self, action: #selector(btnBldGrp_onClick), for: .touchUpInside)
        
        btnTemp.addTarget(self, action: #selector(btnTemp_onClick), for: .touchUpInside)
        
        btnHgtFt.addTarget(self, action: #selector(btnHgtFt_onClick), for: .touchUpInside)
        
          btnFeetA.addTarget(self, action: #selector(btnHgtFt_onClick), for: .touchUpInside)
        
          btnInchA.addTarget(self, action: #selector(btnHgtInch_onClick), for: .touchUpInside)
        
          btnHgtInch.addTarget(self, action: #selector(btnHgtInch_onClick), for: .touchUpInside)
        
        btnDrawPrescription.addTarget(self, action: #selector(btnDraw_onClick), for: .touchUpInside)
        
    }
    
    func setDropDown()
    {
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 20)
        dropdownBloodGrp.arrowIndicationX = 50
        dropdownBloodGrp.anchorView = btnBloodGrp
        dropdownTemp.anchorView = btnTemp
        dropdownFt.anchorView = btnHgtFt
        dropdownInch.anchorView = btnHgtInch
        
        dropdownInch.anchorView = btnInchA
        dropdownFt.anchorView = btnFeetA
        
        dropdownBloodGrp.dataSource = ["O +ve","O -ve","A","B","AB"]
        dropdownTemp.dataSource = ["Hypothermia(<35.0°C)", "Normal(36.5 - 37.5°C)", "Hyperthermia(>37.5 or 38.3°C)", "Hyperpyrexia(>40.0 or 41.5°C)"]
        dropdownFt.dataSource = ["3 ft", "4 ft", "5 ft", "6 ft"]
        dropdownInch.dataSource = ["0 in", "1 in", "2 in", "3 in", "4 in", "5 in", "6 in", "7 in", "8 in", "9 in", "10 in", "11 in"]
        
        
        dropdownTemp.direction = .bottom
        dropdownBloodGrp.direction = .bottom
        dropdownInch.direction = .bottom
        dropdownFt.direction = .bottom
        
        dropdownTemp.bottomOffset = CGPoint(x: 0, y:(dropdownTemp.anchorView?.plainView.bounds.height)!)

        dropdownBloodGrp.bottomOffset = CGPoint(x: 0, y:(dropdownBloodGrp.anchorView?.plainView.bounds.height)!)
        
        dropdownInch.bottomOffset = CGPoint(x: 0, y:(dropdownInch.anchorView?.plainView.bounds.height)!)
        
        dropdownFt.bottomOffset = CGPoint(x: 0, y:(dropdownFt.anchorView?.plainView.bounds.height)!)
    }
  
    @objc func btnBldGrp_onClick()
    {
        dropdownBloodGrp.show()
        dropdownBloodGrp.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtBloodGrp.text = item
        }
    }
    
    @objc func btnTemp_onClick()
    {
        dropdownTemp.show()
        dropdownTemp.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtTemp.text = item
        }
    }
    
    @objc func btnHgtFt_onClick()
    {
        dropdownFt.show()
        dropdownFt.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.btnHgtFt.setTitle(item, for: .normal)
        }
    }

    @objc func btnHgtInch_onClick()
    {
        dropdownInch.show()
        dropdownInch.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.btnHgtInch.setTitle(item, for: .normal)
        }
    }
    
    @objc func btnDraw_onClick()
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
