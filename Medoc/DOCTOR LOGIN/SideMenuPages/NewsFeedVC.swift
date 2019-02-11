//
//  NewsFeedVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/23/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD


class NewsFeedVC: UIViewController
{

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tblNewsFeed: UITableView!
    
    var articleArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblNewsFeed.delegate = self
        tblNewsFeed.dataSource = self
        tblNewsFeed.separatorStyle = .none
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        
        getHealthData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 400
            revealViewController().rightViewRevealWidth = 180
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    @IBAction func btnback_onclick(_ sender: Any)
    {
    }
    
    func getHealthData()
    {
        
        
        let NewsApi = "https://newsapi.org/v2/top-headlines?category=health&country=in&apiKey=c5b24a8c983d4480b5197c75fe2a0308"
        
        Alamofire.request(NewsApi, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                self.articleArr = json["articles"] as! [AnyObject]
                
                self.tblNewsFeed.reloadData()
                break
                
            case .failure(_):
                break
            }
            
            OperationQueue.main.addOperation {
              
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    @objc func OpenWeb(sender : UIButton)
    {
        let vc = AppStoryboard.Doctor.instance.instantiateViewController(withIdentifier: "newsFeedWebViewVC") as! newsFeedWebViewVC
        
        let lcPointInTable = sender.convert(sender.bounds.origin, to: self.tblNewsFeed)
        let lcIndexPath = self.tblNewsFeed.indexPathForRow(at: lcPointInTable)
     
        let lcDict = self.articleArr[(lcIndexPath?.row)!]
        
        if let Url = lcDict["url"] as? String
        {
            vc.urlStr = Url
        }
        
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
extension NewsFeedVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblNewsFeed.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCell
        
        
        let lcdict = self.articleArr[indexPath.row]
        
        if let Title = lcdict["title"] as? String
        {
            cell.lblTitle.text = Title
        }else{
            cell.lblTitle.text = ""
        }
        
        if let Desc = lcdict["description"] as? String
        {
             cell.lblDesc.text = Desc
        }else{
              cell.lblDesc.text = ""
        }
        
        if let time = lcdict["publishedAt"] as? String
        {
             cell.lblTime.text = time
        }else
        {
            cell.lblTime.text = ""
        }
        
       
        if let Img = lcdict["urlToImage"] as? String
        {
            let imgUrl = URL(string: Img)
            
            cell.imgNews.kf.setImage(with: imgUrl)
        }else{
            cell.imgNews.image = UIImage(named : "MedocAppIcon")
        }
        
       
        
        cell.backview.designCell()
        
        cell.btnReadMore.tag = indexPath.row
        cell.btnReadMore.addTarget(self, action: #selector(OpenWeb(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550.0
    }
    
}
