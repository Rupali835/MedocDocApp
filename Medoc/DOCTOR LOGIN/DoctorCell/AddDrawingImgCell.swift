//
//  AddDrawingImgCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/19/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class AddDrawingImgCell: UITableViewCell {

    
    @IBOutlet weak var lbl_imgTag: UILabel!
    @IBOutlet weak var btndeleteImg: UIButton!
    @IBOutlet weak var imgDrawing: UIImageView!
    @IBOutlet weak var backview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
