//
//  AppDelegate.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 19/07/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GoogleMobileAds
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isColdStart = true
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleAPIKey)
        // UIApplication.shared.statusBarView?.backgroundColor = UIColor.blue
        IQKeyboardManager.shared.enable = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        //GoogleApi.shared.initialiseWithKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
       // isfirstLaunch()
//        if !UserDefaults.standard.bool(forKey: "MessagePopUp") {
//            UserDefaults.standard.set(true, forKey: "MessagePopUp")
//       }
      
       // checkLaunch()
        if Defaults.MemberModel.getMemberModel() != nil {
               checkLaunch(true)
           } else {
               checkLaunch(false)
           }
        
        return true
    }
    //MARK:- To Set The Verification Page On ColdStart Of The App
    func checkLaunch(_ isLaunch:Bool) {
        let isLaunch = UserDefaults.standard.bool(forKey: "launchedBefore")
        if isLaunch  {
             //Not the first time, show Main Home screen.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homePage)
            nav.isNavigationBarHidden = false
            nav.navigationBar.tintColor = .black
            nav.navigationBar.barTintColor = .white
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        else {
           // UserDefaults.standard.set(true, forKey: "launchedBefore")
            //First time, open Retrive Account view controller.
            let  storyboard = UIStoryboard(name: "Main", bundle: nil)
            let retriveAccount = storyboard.instantiateViewController(withIdentifier: "RetriveAccountVC") as! RetriveAccountVC
            self.window?.rootViewController = UINavigationController(rootViewController: retriveAccount)
            self.window?.makeKeyAndVisible()
            
        }
        
    }
    
    
    //MARK: FirstLaunch
    
//    func isfirstLaunch()
//    {
//        if UserDefaults.isFirstLaunch() {
//
//            UserDefaults.standard.set(Date(), forKey:"DateSavedAfterAppInstall")
//
//        }
//
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}



