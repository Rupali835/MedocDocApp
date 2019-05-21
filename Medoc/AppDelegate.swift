//
//  AppDelegate.swift
//  Medoc
//
//  Created by Prem Sahni on 27/11/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import Firebase
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import IQKeyboardManager
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.shared().isEnabled = true
       DropDown.startListeningToKeyboard()
        
        Thread.sleep(forTimeInterval: 2.0)
       let result = UserDefaults.standard.value(forKey: "userData")
        print(result)
        if result != nil {
           let yourVc : SWRevealViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.setViewControllers([yourVc], animated: true)
        }
        
       return true
     
    }
    
  
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Medoc")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

