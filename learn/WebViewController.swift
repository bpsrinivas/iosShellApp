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
       
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    /* Methods to be called from Javascript -- START */
    
    func printOnIosFromJS(str:String){
        print(str);
    }
    
    func navigateToUrlEntryScreen(){
        print("Navigate to the url entry screen now ");
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
        print("request for \(request.URL!.absoluteString)")
        let absoluteUrl = request.URL!.absoluteString;
        print("sheme --> \(request.URL!.scheme)");
        
        if request.URL != nil && request.URL!.scheme == "learntron" {
            print("------ JS CALLED ME --------")
            let methodName = request.URL!.host!;
            switch methodName {
                case "printOnIosFromJS":
                    printOnIosFromJS(getQueryParamFromStr(absoluteUrl)["str"]!);
                case "navigateToUrlEntryScreen":
                    navigateToUrlEntryScreen();
            default:
                    print("INVALID METHOD NAME");
            }
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
