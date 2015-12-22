//
//  AppDelegate.swift
//  外滩
//
//  Created by 彭然 on 15/10/15.
//  Copyright © 2015年 外滩画报. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        UMSocialData.setAppKey("549a6067fd98c588990003ca")
        UMSocialWechatHandler.setWXAppId("wxd1adb4ea31ffefeb", appSecret: "ab616d4542e0a43b627536a37dfea284", url: "http://www.bundpic.com")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        var urlArr = url.absoluteString.componentsSeparatedByString("://")
        
        sharedData.webUrl = urlArr.count > 1 ? urlArr[1] : ""
//        sharedData.webUrl = sharedData.webUrl.stringByReplacingOccurrencesOfString("http//", withString: "")

        let navController = self.window?.rootViewController as! UINavigationController
        let mainController = navController.viewControllers[0] as! ViewController
        self.window?.makeKeyAndVisible()
        mainController.performSegueWithIdentifier("openWeb", sender: self)
        
//        let rController = [UINavigationController]self.window!.rootViewController;
//        let r = rController
//        ([UINavigationController]).rootViewController;
//        rController!.performSegueWithIdentifier("openWeb", sender: nil)
        return true;
    }

}

struct sharedData {
    static var webUrl: String = ""
    static var webTitle: String = ""
    static var webImage: String = ""
    static var webPostid: String = ""
    static var webUsertoken: String = ""
    static var webHideBtn: Bool = false
    
}
