//
//  DrListCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/6/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class DrListCell: UITableViewCell {

    @IBOutlet weak var btnMark: CheckboxButton!
    @IBOutlet weak var lblDrList: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        backView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
