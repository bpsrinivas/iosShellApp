//
//  WebViewController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class WebViewController : UIViewController{
    
    var pathToLaunchFile:String = "";
    
    @IBOutlet weak var learnTronWebView: UIWebView!
    
    func loadAnyUrl(someUrl: String){
        learnTronWebView.loadRequest(NSURLRequest(URL: NSURL(string: someUrl)!));
    }
    
    func loadLaunchHtml(htmlPageName: String){
        let url = NSBundle.mainBundle().URLForResource(htmlPageName,
                                                       withExtension:"html",
                                                       subdirectory: "lib")
        learnTronWebView.loadRequest(NSURLRequest(URL: url!));
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("web view should load file from the path");
        let launchUrl = ProgressBarController().getLibDirectoryUrl().URLByAppendingPathComponent("test/index.html");
        print("\(launchUrl.absoluteString)");
        learnTronWebView.loadRequest(NSURLRequest(URL: launchUrl));
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
