//
//  PatientPrescriptionListCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/16/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class PatientPrescriptionListCell: UITableViewCell {

    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblPatproblem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
