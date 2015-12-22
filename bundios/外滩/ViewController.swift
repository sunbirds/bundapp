//
//  ViewController.swift
//  外滩
//
//  Created by 彭然 on 15/10/15.
//  Copyright © 2015年 外滩画报. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKScriptMessageHandler, WKNavigationDelegate, UMSocialUIDelegate{
    
    @IBOutlet weak var splash: UIView!

    var web: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scriptHandle = WKUserContentController()
        scriptHandle.addScriptMessageHandler(self, name: "share")
        scriptHandle.addScriptMessageHandler(self, name: "inappbrowser")
        scriptHandle.addScriptMessageHandler(self, name: "newinappbrowser")
        
        let config = WKWebViewConfiguration()
        
//        config.userContentController.addUserScript(script)
        config.userContentController = scriptHandle       //初始化WKWebView
        
        web = WKWebView(
            frame: CGRectMake(0, -20, self.view.frame.width , self.view.frame.height+20),
            configuration: config)
        web.navigationDelegate = self
//        self.view.insertSubview(web, atIndex:self.view.subviews.count)
        self.view.insertSubview(web, belowSubview: splash)
//        self.view.addSubview(web)
//        self.view.bringSubviewToFront(splash)
        // Do any additional setup after loading the view, typically from a nib.

        web.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.bundpic.com/webapp/index.html?app=true")!))
//        web.hidden = true
        print(web.layer.zPosition)
        print(splash.layer.zPosition)
//        web.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.apple.com")!))
//        web.loadRequest(NSURLRequest(URL: NSURL(string: "http://localhost:3000/bundshop/?app=true")!))
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if(message.name == "share") {
            let funcString = message.body
            if funcString.hasPrefix("doFavorite"){
                var params = funcString.stringByReplacingOccurrencesOfString("doFavorite?title=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("image=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("link=", withString: "")
                var paramsArr = params.componentsSeparatedByString("&")

                if paramsArr[0] == "" || paramsArr[1] == "" || paramsArr[2] == ""{
                    return ;
                }
                
                let title = paramsArr[0].stringByRemovingPercentEncoding
                let img = paramsArr[1].stringByRemovingPercentEncoding
                let link = paramsArr[2].stringByRemovingPercentEncoding
                
                Utils.fav(title! ,shareImage: img! ,shareLink: link!,view: self,del: self);
            }
        } else if (message.name == "newinappbrowser") {
            let iabMessage = message.body
            
            if iabMessage.hasPrefix("doinappbrowser"){
                var params = iabMessage.stringByReplacingOccurrencesOfString("doinappbrowser?title=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("image=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("link=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("postid=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("usertoken=", withString: "")
                params = params.stringByReplacingOccurrencesOfString("hidebtn=", withString: "")
                var paramsArr = params.componentsSeparatedByString("&app")
                
                if paramsArr[0] == "" || paramsArr[1] == "" || paramsArr[2] == ""{
                    return ;
                }
                
                sharedData.webTitle = paramsArr[0].stringByRemovingPercentEncoding!
                sharedData.webImage = paramsArr[1].stringByRemovingPercentEncoding!
                sharedData.webUrl = paramsArr[2].stringByRemovingPercentEncoding!
                sharedData.webPostid = paramsArr[3].stringByRemovingPercentEncoding!
                sharedData.webUsertoken = paramsArr[4].stringByRemovingPercentEncoding!
                sharedData.webHideBtn = false
//                if(paramsArr.count > 5){
//                    sharedData.webHideBtn = paramsArr[5].stringByRemovingPercentEncoding!
//                }
                
//                                print(sharedData.webTitle)
//                                print(sharedData.webImage)
//                                print(sharedData.webUrl)
//                                print(sharedData.webPostid)
//                                print(sharedData.webUsertoken)
                self.performSegueWithIdentifier("openWeb", sender: self)
            }else if iabMessage.hasPrefix("doad"){
                let params = iabMessage.stringByReplacingOccurrencesOfString("doad?link=", withString: "")
                sharedData.webUrl = params
                sharedData.webHideBtn = true
                self.performSegueWithIdentifier("openWeb", sender: self)
            }
            
            
        }
//        else if (message.name == "inappbrowser") {
//            print("1111111111")
//            sharedData.webUrl = message.body as! String
//            self.performSegueWithIdentifier("openWeb", sender: self)
//            
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func hidesplash() {
        // Something cool
        splash.hidden = true
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "hidesplash", userInfo: nil, repeats: true)
        hidesplash()
    }
    
};

