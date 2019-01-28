//
//  SearchPatientbyContactCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/10/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class SearchPatientbyContactCell: UITableViewCell {

    
    @IBOutlet weak var lblFirstLetter: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
