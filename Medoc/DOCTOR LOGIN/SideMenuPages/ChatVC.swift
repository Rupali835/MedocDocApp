//
//  ChatVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/6/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tblDrList: UITableView!
    
    var DrListArr = ["Dr. Aasha Singh", "Dr. Neeraj Ahuja", "Dr. Pramod Patel", "Dr. Priya Sule", "Dr. Ashwin Sinh", "Dr. Pradip Bhatiya", "Dr.Vijay Kumar", "Dr. Prakash More"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblDrList.delegate = self
        tblDrList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sideMenus()
    {
        
        if revealViewController() != nil {
            
            self.btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
        }
    }
    

    
}
extension ChatVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DrListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblDrList.dequeueReusableCell(withIdentifier: "DrListCell") as! DrListCell
        cell.lblDrList.text = self.DrListArr[indexPath.row]
        cell.backView.designCell()
        return cell
    }
}
