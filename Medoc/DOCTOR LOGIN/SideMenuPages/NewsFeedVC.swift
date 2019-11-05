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
   
    
    @IBOutlet weak var collNews: UICollectionView!
    var articleArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collNews.delegate = self
        collNews.dataSource = self
        
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
            if UIDevice.current.userInterfaceIdiom == .pad {
                revealViewController().rearViewRevealWidth = 400
                revealViewController().rightViewRevealWidth = 180
            } else {
                revealViewController().rearViewRevealWidth = 260
                revealViewController().rightViewRevealWidth = 180
            }
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
          
            
            OperationQueue.main.addOperation {
                
                SVProgressHUD.dismiss()
            }
            
            switch resp.result
            {
            
            case .success(_):
                let json = resp.result.value as! NSDictionary
                
                guard let NewsArr = json["articles"] as? [AnyObject] else
                {
                    
                    return
                }
                self.articleArr = NewsArr
                
              //  self.articleArr = json["articles"] as! [AnyObject]
                
                self.collNews.reloadData()
                break
                
            case .failure(_):
                break
            }
            
          
        }
        
    }
    
    @objc func OpenWeb(sender : UIButton)
    {
        var appstory = AppStoryboard.Doctor
        if UIDevice.current.userInterfaceIdiom == .pad {
            appstory = AppStoryboard.Doctor
        } else {
            appstory = AppStoryboard.IphoneDoctor
        }
        let vc = appstory.instance.instantiateViewController(withIdentifier: "newsFeedWebViewVC") as! newsFeedWebViewVC
        
        let lcPointInTable = sender.convert(sender.bounds.origin, to: self.collNews)
        let lcIndexPath = self.collNews.indexPathForItem(at: lcPointInTable)
     
        let lcDict = self.articleArr[(lcIndexPath?.row)!]
        
        if let Url = lcDict["url"] as? String
        {
            vc.urlStr = Url
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension NewsFeedVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       let cell = collNews.dequeueReusableCell(withReuseIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCell
        
        let lcdict = self.articleArr[indexPath.row]
        
        if let Title = lcdict["title"] as? String
        {
            cell.lblTitle.text = Title
        }else{
            cell.lblTitle.text = ""
        }
        
//        if let Desc = lcdict["description"] as? String
//        {
//            cell.lblDesc.text = Desc
//        }else{
//            cell.lblDesc.text = ""
//        }
//
//        if let time = lcdict["publishedAt"] as? String
//        {
//            cell.lblTime.text = time
//        }else
//        {
//            cell.lblTime.text = ""
//        }
//
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: ((self.collNews.frame.size.width) / 3) - (10+5), height: (self.collNews.frame.size.width) / 3)
       }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
}
