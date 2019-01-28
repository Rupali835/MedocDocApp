//
//  NewsFeedHomePageCell.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/28/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class NewsFeedHomePageCell: UICollectionViewCell
{
    
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var newslbl: UILabel!
    @IBOutlet weak var newsimg: UIImageView!
    @IBOutlet weak var backview: UIView!
    
    // this will be our "call back" action
    var btnTapAction : (()->())?
    
    func btnTapped() {
        print("Tapped!")
        
        // use our "call back" action to tell the controller the button was tapped
        btnTapAction?()
    }
}
