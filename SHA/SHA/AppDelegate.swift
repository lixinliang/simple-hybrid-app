//
//  AppDelegate.swift
//  SHA
//
//  Created by 李昕亮 on 2016/12/28.
//  Copyright © 2016年 李昕亮. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 蓝色背景
        window!.backgroundColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1)
        
        let view = window!.rootViewController!.view!
        
        // 白底
        let cover = UIView(frame: view.frame)
        cover.backgroundColor = .white
        view.addSubview(cover)
        
        // 遮罩
        let mask = CALayer()
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.position = view.center
        mask.contents = UIImage(named: "mask")?.cgImage
        view.layer.mask = mask

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


}

