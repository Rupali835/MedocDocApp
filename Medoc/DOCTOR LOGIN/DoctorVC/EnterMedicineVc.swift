//
//  EnterMedicineVc.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/12/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import DropDown

class EnterMedicineVc: UIViewController {

    @IBOutlet weak var btntextTiming: UIButton!
    @IBOutlet weak var btntextAmount: UIButton!
    @IBOutlet weak var btntextType: UIButton!
    @IBOutlet weak var txtMedicinenm: UITextField!
    @IBOutlet weak var btnType: UIButton!
    
    @IBOutlet weak var btnTiming: UIButton!
    @IBOutlet weak var btnAmount: UIButton!
    let dropDownType = DropDown()
    let dropDownAmount = DropDown()
    let dropDownTiming = DropDown()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dropDownType.anchorView = btnType
        dropDownType.direction = .bottom
        dropDownType.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownType.dataSource = ["Tablet", "Syrup", "Tube", "Drop"]

        dropDownAmount.anchorView = btnAmount
        dropDownAmount.direction = .bottom
        dropDownAmount.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownAmount.dataSource = ["1 Tablet", "1½ Tablet", "2 Tablet"]
      

        dropDownTiming.anchorView = btnTiming
        dropDownTiming.direction = .bottom
        dropDownTiming.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownTiming.dataSource = ["Daily", "Weekly", "Time Interval"]
      

        
    }
    
    @IBAction func btnSelectType_onClick(_ sender: Any)
    {
        dropDownType.show()
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btntextType.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func btnAmount_onclick(_ sender: Any)
    {
        dropDownAmount.show()
        dropDownAmount.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btntextAmount.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func btnTiming_onClick(_ sender: Any)
    {
        dropDownTiming.show()
        dropDownTiming.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btntextTiming.setTitle(item, for: .normal)
            
        }
    }
    
}
