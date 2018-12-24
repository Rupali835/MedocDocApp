//
//  SearchPatientCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/20/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class SearchPatientCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPAtDesc: UILabel!
    @IBOutlet weak var lblPatID: UILabel!
    @IBOutlet weak var lblNm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
