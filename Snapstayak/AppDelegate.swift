//
//  AppDelegate.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/19/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwipeNavigationController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainSwipeNavigationController: SwipeNavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let centerStoryboard = UIStoryboard(name: "Center", bundle: nil)
        let centerViewController = centerStoryboard.instantiateInitialViewController()
        let swipeNavigationController = SwipeNavigationController(centerViewController: centerViewController!)
        self.mainSwipeNavigationController = swipeNavigationController
        
        swipeNavigationController.leftViewController = DetailsViewController()
        
        let topStoryboard = UIStoryboard(name: "Top", bundle: nil)
        swipeNavigationController.topViewController = topStoryboard.instantiateInitialViewController()
        
        swipeNavigationController.rightViewController = CameraViewController()
        // swipeNavigationController.showEmbeddedView(position: .right) // this makes the right (camera) container open first by default (desired feature, commenting out temporarily to work on the Center container)
        
        self.window?.rootViewController = swipeNavigationController
        
        return true
    }

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

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        print("url \(url)")
        print("url host :\(url.host as String!)")
        print("url path :\(url.path as String!)")
        alert(title: "WIP", message: "Login Successful", button: "Alrighty...");
        
        
        var urlPath : String = url.path as String!
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
//        if(urlPath == "/about"){
//            self.window?.rootViewController = aboutVC
//        }
        
        self.window?.makeKeyAndVisible()
        return true
    }
}

func delay(_ delay: Double, closure: (()->())?) { // Copied from my previous CodePath assignments -- Tejen
    if(closure == nil) {
        return;
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure!()
    }
}

func alert(title: String, message: String, button: String) {
    let alertController = UIAlertController(title: title, message:
        message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default,handler: nil));
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        delay(0.1, closure: {
            topController.present(alertController, animated: true, completion: nil);
        });
    }
}
