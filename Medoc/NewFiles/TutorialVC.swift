//
//  TutorialVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 2/5/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController
{

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var collTutorial: UICollectionView!
    
    var TutorialImgArr = ["MedocAppIcon", "FirstHomeScreen1", "AddNewPatient", "AddExistingPatient", "showPatient", "AddPrescfirst", "PrescMedicine"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        collTutorial.delegate = self
        collTutorial.dataSource = self
       pageControl.numberOfPages = TutorialImgArr.count
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = self.collTutorial.contentOffset
        visibleRect.size = self.collTutorial.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.collTutorial.indexPathForItem(at: visiblePoint) else { return }
        
        print(indexPath)
        self.pageControl.currentPage = indexPath.item
        
        
        
    }
    
    @IBAction func btnSkip_onclick(_ sender: Any)
    {
        var appstory = AppStoryboard.Main
        if UIDevice.current.userInterfaceIdiom == .pad {
            appstory = AppStoryboard.Main
        } else {
            appstory = AppStoryboard.IphoneMain
        }
        let yourVc : SWRevealViewController = appstory.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window!.rootViewController as! UINavigationController
        navigationController.setViewControllers([yourVc], animated: true)

    }
    
}
extension TutorialVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.TutorialImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collTutorial.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as! TutorialCell
        
        let lcImg = TutorialImgArr[indexPath.row]
        cell.imgTutorial.image = UIImage(named: lcImg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collTutorial.frame.width, height: self.collTutorial.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
