//
//  InAppBrowserViewController.swift
//  外滩
//
//  Created by 彭然 on 15/10/20.
//  Copyright © 2015年 外滩画报. All rights reserved.
//

import UIKit
import WebKit

class InAppBrowserViewController: UIViewController, WKNavigationDelegate, UMSocialUIDelegate{

    var web: WKWebView!
    
    @IBOutlet weak var iosfav: UIButton!
    @IBAction func onClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func swipeBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    @IBOutlet weak var share: UIButton!
    @IBAction func onShare(sender: AnyObject) {

        let title = sharedData.webTitle
        let img = sharedData.webImage
        let link =  sharedData.webUrl
        
        Utils.fav(title ,shareImage: img ,shareLink: link,view: self,del: self);
    }
    
    @IBAction func onFav(sender: AnyObject) {
//        let postid = sharedData.webPostid
        let usertoken = sharedData.webUsertoken
        if (usertoken ==  "undefined" ){
            let alertController = UIAlertController(title: "", message:
                "请登录后收藏!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let url = NSURL(string:"http://www.bundpic.com/app-addfav?p="+sharedData.webPostid+"&c="+sharedData.webUsertoken)
            let request = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                let favData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if (favData == "0"){
                    let onfavImage = UIImage(named: "onfav")! as UIImage
                    sender.setImage(onfavImage,forState: UIControlState.Normal)
                    self.view.makeToast(message: "收藏成功",duration: 1.5, position: HRToastPositionCenter)
                }else if(favData == "5"){
                    let url = NSURL(string:"http://www.bundpic.com/app-delfav?p="+sharedData.webPostid+"&c="+sharedData.webUsertoken)
                    let request = NSURLRequest(URL: url!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                        let favData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        if (favData == "0"){
                            let onfavImage = UIImage(named: "fav")! as UIImage
                            sender.setImage(onfavImage,forState: UIControlState.Normal)
                            self.view.makeToast(message: "取消收藏",duration: 1.5, position: HRToastPositionCenter)
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web = WKWebView(frame: CGRectMake(0, 44, self.view.frame.width, self.view.frame.height))
        web.navigationDelegate = self
        self.view.insertSubview(web, atIndex: 0)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeBack:"))
        
        rightSwipe.direction = .Right
        
        web.addGestureRecognizer(rightSwipe)
        
        if(sharedData.webHideBtn){
            share.hidden = true
            iosfav.hidden = true
        }
        
        // Do any additional setup after loading the view, typically from a nib.

        if (sharedData.webUrl.hasPrefix("http://") || sharedData.webUrl.hasPrefix("https://")){
            sharedData.webUrl = sharedData.webUrl.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            web.loadRequest(NSURLRequest(URL: NSURL(string: "\(sharedData.webUrl)")!));
        }else{
            sharedData.webUrl = sharedData.webUrl.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            web.loadRequest(NSURLRequest(URL: NSURL(string: "http://\(sharedData.webUrl)")!))
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}