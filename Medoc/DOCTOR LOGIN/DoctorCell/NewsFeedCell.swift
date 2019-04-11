//
//  NewsFeedCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/23/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class NewsFeedCell: UICollectionViewCell {

    @IBOutlet weak var imgNews: UIImageView!
    
    
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
      @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        btnReadMore.layer.borderColor = UIColor.darkGray.cgColor
        btnReadMore.layer.borderWidth = 1.0
    }
    
  
    
}
