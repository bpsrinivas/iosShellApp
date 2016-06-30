//
//  WebViewController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class WebViewController : UIViewController, UIWebViewDelegate{
    
    var pathToLaunchFile:String = "";
    
    @IBOutlet weak var learnTronWebView: UIWebView!
    @IBOutlet weak var busyThrobber: UIActivityIndicatorView!
    
    func onViewLoaded(){
        let launchUrl = ProgressBarController().getLibDirectoryUrl().URLByAppendingPathComponent(Constants.indexFileInZip);
        learnTronWebView.delegate = self;
        learnTronWebView.loadRequest(NSURLRequest(URL: launchUrl));
    }
    
    override func viewDidLoad() {
        print("webViewController comes to view did load");
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
        print("Started to load html");
        busyThrobber.startAnimating();
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        print("Completed loading html");
        busyThrobber.stopAnimating();
        executeOnLoadJS();
    }
    
    func executeOnLoadJS(){
        //executeJSOnWebView("alert('the html page is loaded, This js is inititaed from web view');")
    }
    
    func printOnIosFromJS(str:String){
        print(str);
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("request for \(request.URL?.path)")
        if request.URL!.scheme == "learntron://" {
            print("Hello JavaScript...")
            print(request.URL?.path);
            print(request.URL?.parameterString);
            return false;
        }else{
            return true;
        }
    }
    
    /*func loadAnyUrl(someUrl: String){
     learnTronWebView.loadRequest(NSURLRequest(URL: NSURL(string: someUrl)!));
     }
     
     func loadLaunchHtml(htmlPageName: String){
     let url = NSBundle.mainBundle().URLForResource(htmlPageName,
     withExtension:"html",
     subdirectory: "lib")
     
     learnTronWebView.loadRequest(NSURLRequest(URL: url!));
     }*/

}
