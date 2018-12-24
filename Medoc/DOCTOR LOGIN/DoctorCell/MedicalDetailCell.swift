//
//  MedicalDetailCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/21/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class MedicalDetailCell: UITableViewCell {

    @IBOutlet weak var lblThirdTime: UILabel!
    @IBOutlet weak var lblSecondTime: UILabel!
    @IBOutlet weak var btnCancelMedicine: UIButton!
    @IBOutlet weak var lblMedicalTime: UILabel!
    @IBOutlet weak var lblMedicalNm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       setTextField(text: lblMedicalNm)
        setTextField(text: lblMedicalTime)
        setTextField(text: lblSecondTime)
        setTextField(text: lblThirdTime)
        
        lblMedicalTime.sizeToFit()
        lblMedicalNm.sizeToFit()
        
        self.selectionStyle = .none
        
        self.btnCancelMedicine.layer.borderColor = UIColor(red:0.70, green:0.16, blue:0.13, alpha:1.0).cgColor
        self.btnCancelMedicine.layer.borderWidth = 1.0
        
    }

    func setTextField(text: UILabel)
    {
        text.layer.borderWidth = 0.7
        text.layer.borderColor = UIColor(red:1.00, green:0.77, blue:0.00, alpha:1.0).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
