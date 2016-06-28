//
//  ViewController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var zipFileUrl: UITextField!
    var defaultUrl:String = "http://Pradeeps-MacBook-Pro.local:8000/test.zip";
    
    @IBAction func onOkClicked(sender: AnyObject) {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let progressBarController = segue.destinationViewController as?ProgressBarController
        progressBarController!.url = zipFileUrl.text!;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        zipFileUrl.text = defaultUrl;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

