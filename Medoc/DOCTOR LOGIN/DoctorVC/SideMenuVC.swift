//
//  SideMenuVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 12/17/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController
{

    @IBOutlet weak var tblSideList: UITableView!
    
    var SideListArr = ["Today's Patient", "Add Report", "Profile", "Your QR Code", "Chat", "Rate Us", "Contact Us", "Purchases"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblSideList.delegate = self
        tblSideList.dataSource = self
        tblSideList.separatorStyle = .none
        
    }
 
}
extension SideMenuVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SideListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSideList.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        cell.lblSideNm.text = self.SideListArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
