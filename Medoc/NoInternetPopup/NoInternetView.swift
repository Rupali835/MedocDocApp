//
//  NoInternetView.swift
//  Medoc
//
//  Created by Prajakta Bagade on 4/17/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class AddclinicView: UIView {

    @IBOutlet weak var lblchecknet: UILabel!
  
    required init?(coder aDecoder: NSCoder) {
      
        super.init(coder: aDecoder)
        _ = loadViewFromNib()
    }

    private func loadViewFromNib() -> UIView
    {
       let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "NoInternetView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view!)
        return view!
        
    }
    
    @IBAction func btnTryAgain_onClick(_ sender: Any)
    {
        
    }
}
