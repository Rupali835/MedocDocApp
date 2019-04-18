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


    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtSchedule: UITextField!
    @IBOutlet weak var txtInstructions: UITextField!
    @IBOutlet weak var txtMedicineType: UITextField!
    @IBOutlet weak var txtMedicinenm: UITextField!

    let dropDownType = DropDown()
    let dropDownInstruction = DropDown()
    let dropDownTiming = DropDown()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        txtSchedule.delegate = self
        txtMedicineType.delegate = self
        txtInstructions.delegate = self
        
        dropDownType.anchorView = txtMedicineType
        dropDownType.direction = .bottom
        dropDownType.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownType.dataSource = ["Capsules", "Cream", "Drops", "Gel", "Inhaler", "Injection", "Lotion", "Mouthwash", "Ointment", "Others", "Physiotherapy", "Powder", "Spray", "Suppository", "Syrup", "Tablet", "Treatment Session"]

        dropDownInstruction.anchorView = txtInstructions
        dropDownInstruction.direction = .bottom
        dropDownInstruction.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownInstruction.dataSource = ["Before meal", "After meal", "During meal", "Empty stomach", "With warm water", "Never take with milk", "Avoid sugar", "Avoid salty food", "Avoid fatty food", "Eat more vegetable", "Eat more iron-rich food", "No specific instruction"]


        dropDownTiming.anchorView = txtSchedule
        dropDownTiming.direction = .bottom
        dropDownTiming.bottomOffset = CGPoint(x: 0, y:(dropDownType.anchorView?.plainView.bounds.height)!)
        dropDownTiming.dataSource = ["Once", "Daily", "Weekly", "Time Interval"]


        
    }
   
    @IBAction func btnBack_onclick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    @IBAction func btnSelectType_onClick(_ sender: Any)
    {
        dropDownType.show()
        dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnType.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func btnAmount_onclick(_ sender: Any)
    {
        dropDownAmount.show()
        dropDownAmount.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnAmount.setTitle(item, for: .normal)
            
        }
    }
    
    @IBAction func btnTiming_onClick(_ sender: Any)
    {
        dropDownTiming.show()
        dropDownTiming.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.btnTiming.setTitle(item, for: .normal)
            
        }
    }
 
 */
    
}

extension EnterMedicineVc : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtMedicineType
        {
            dropDownType.show()
            dropDownType.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
               self.txtMedicineType.text = item
                
            }
        }
        
        if textField == txtInstructions
        {
            dropDownInstruction.show()
            dropDownInstruction.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.txtInstructions.text = item
                
            }
        }
        
        if textField == txtSchedule
        {
            dropDownTiming.show()
            dropDownTiming.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.txtSchedule.text = item
                
            }
        }
    }
}
