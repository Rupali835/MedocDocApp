//
//  VideoListVC.swift
//  Medoc
//
//  Created by Prajakta Bagade on 1/7/19.
//  Copyright © 2019 Kanishka. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoListVC: UIViewController
{

    @IBOutlet weak var btnback: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    
    @IBAction func btnShowvideo_onclick(_ sender: Any)
    {
        playVideo()
    }
    
    private func playVideo()
    {
        guard let path = Bundle.main.path(forResource: "Phlebotomy- Syringe Draw Procedure - Blood Collection (Rx-TN)", ofType:"mp4")
            else {
                debugPrint("video.m4v not found")
                return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
        
    }
    
    @IBAction func btnBacak_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    func sideMenus()
    {
        
        if revealViewController() != nil {
            
            self.btnback.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            if UIDevice.current.userInterfaceIdiom == .pad {
                revealViewController().rearViewRevealWidth = 400
                revealViewController().rightViewRevealWidth = 180
            } else {
                revealViewController().rearViewRevealWidth = 260
                revealViewController().rightViewRevealWidth = 180
            }
        }
    }
}
