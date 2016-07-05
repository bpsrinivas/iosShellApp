//
//  Commons.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 05/07/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

public class Commons{
    
    class func showOkAlert(controller:UIViewController, msg:String, handler:((UIAlertAction)->Void)?){
        let alertController = UIAlertController(title: "LearnTron", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
        let alertAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:handler)
        alertController.addAction(alertAction);
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func getLibDirectoryUrl() -> NSURL{
        let fileManager = NSFileManager.defaultManager();
        let libraryDirectory:NSArray = fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask);
        let libDirUrl:NSURL = libraryDirectory.firstObject as! NSURL;
        return libDirUrl;
    }
    
    class func isNetworkAvailable()->Bool{
        return Reachability.isConnectedToNetwork();
    }
}
