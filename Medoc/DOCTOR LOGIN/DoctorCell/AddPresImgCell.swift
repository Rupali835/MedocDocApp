//
//  AddPresImgCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/11/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class AddPresImgCell: UITableViewCell
{

    @IBOutlet weak var lblimgNm: UILabel!
    @IBOutlet weak var btnDeleteImg: UIButton!
    @IBOutlet weak var imgPres: UIImageView!
    @IBOutlet weak var backview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
