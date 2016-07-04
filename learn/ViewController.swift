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
    
    var defaultUrl:String = Constants.defaultZipFileUrl;
    
    @IBAction func onOkClicked(sender: AnyObject) {
        
    }
    
    func onViewLoaded(){
        zipFileUrl.text = defaultUrl;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let progressBarController = segue.destinationViewController as?ProgressBarController
        progressBarController!.url = zipFileUrl.text!;
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(Reachability.isConnectedToNetwork()){
            return true;
        }else{
            let alertController = UIAlertController(title: "LearnTron", message: "You are not connected to Internet", preferredStyle: UIAlertControllerStyle.Alert);
        
            alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil));
            return false;
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        onViewLoaded();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

