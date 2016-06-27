//
//  WebViewController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class WebViewController : UIViewController{
    
   
    @IBOutlet weak var learnTronWebView: UIWebView!
    
    func loadAnyUrl(someUrl: String){
        learnTronWebView.loadRequest(NSURLRequest(URL: NSURL(string: someUrl)!));
    }
    
    func loadLaunchHtml(htmlPageName: String){
        let url = NSBundle.mainBundle().URLForResource(htmlPageName,
                                                       withExtension:"html",
                                                       subdirectory: "www")
        learnTronWebView.loadRequest(NSURLRequest(URL: url!));
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLaunchHtml("index");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
