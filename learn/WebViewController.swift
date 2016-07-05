//
//  WebViewController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class WebViewController : UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var learnTronWebView: UIWebView!
    @IBOutlet weak var busyThrobber: UIActivityIndicatorView!
    
    func onViewLoaded(){
        let launchUrl = Commons.getLibDirectoryUrl().URLByAppendingPathComponent(Constants.indexFileInZip);
        learnTronWebView.delegate = self;
        learnTronWebView.loadRequest(NSURLRequest(URL: launchUrl));
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        onViewLoaded();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
    //method to communicate from webview on to the html
    func executeJSOnWebView(jsString:String) -> String?{
        return learnTronWebView.stringByEvaluatingJavaScriptFromString(jsString);
    }
    
    
    func webViewDidStartLoad(webView: UIWebView){
        busyThrobber.startAnimating();
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        busyThrobber.stopAnimating();
        executeOnLoadJS();
    }
    
    func executeOnLoadJS(){
        //executeJSOnWebView("alert('the html page is loaded, This js is inititaed from web view');")
    }
    
    /* Methods to be called from Javascript -- START */
    
    func printOnIosFromJS(str:String){
        print(str);
    }
    
    func navigateToUrlEntryScreen(){
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("urlEntryViewController") as! ViewController;
        self.presentViewController(nextController, animated: true, completion: nil);
    }
    
    
    /* Methods to be called from Javascript -- END */
    
    func getQueryParamFromStr(str:String) -> [String:String]{
        let str1 = str.stringByRemovingPercentEncoding!;
        let components = str1.componentsSeparatedByString("?");
        print(components)
        let paramString = components[1];
        let paramComponents = paramString.componentsSeparatedByString("&");
        var d = [String:String]();
        
        for paramsComp in paramComponents{
            var pair = paramsComp.componentsSeparatedByString("=");
            d.updateValue(pair[1], forKey: pair[0]);
        }
        return d;
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let absoluteUrl = request.URL!.absoluteString;
        if let url = request.URL{
            if url.scheme == "learntron"{
                if let method = url.host{
                    switch method{
                        case "printOnIosFromJS":
                            printOnIosFromJS(getQueryParamFromStr(absoluteUrl)["str"]!);
                            break;
                        case "navigateToUrlEntryScreen":
                            navigateToUrlEntryScreen();
                            break;
                        default:
                            print("\(method)is not defined in the Swift layer");
                    }
                    return false;
                }
            }
        }
        return true;
    }
}
