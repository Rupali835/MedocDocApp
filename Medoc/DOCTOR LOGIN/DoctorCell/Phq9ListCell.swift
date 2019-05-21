//
//  Phq9ListCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/30/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class Phq9ListCell: UITableViewCell
{
   
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.selectionStyle = .none
    }

}
