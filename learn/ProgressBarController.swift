//
//  ProgressBarController.swift
//  learn
//
//  Created by Pradeep Balakrishnan on 24/06/16.
//  Copyright © 2016 LearnTron. All rights reserved.
//

import UIKit

class ProgressBarController : UIViewController, NSURLSessionDownloadDelegate{
    
    var url:String = "";
    var downLoadTask: NSURLSessionDownloadTask!;
    var downloadSession: NSURLSession!;
    var downloadProgress: Double = 0.0;
    var unzippedLocation:String = "";
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressPercentage: UILabel!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webViewController = segue.destinationViewController as! WebViewController;
        webViewController.pathToLaunchFile = unzippedLocation;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlObj:NSURL = NSURL(string: url)!;
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let downloadTask = session.downloadTaskWithURL(urlObj)
        downloadTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("downloadProgress: \(downloadProgress)")
        updateProgress(downloadProgress);
    }
    
    
    func moveToWebViewController(unzippedLocation:String){
        print("move to Web View Controller \(unzippedLocation)");
        
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController;
        
        nextController.pathToLaunchFile = unzippedLocation;
        self.presentViewController(nextController, animated: true, completion: nil);
    }
    
    func updateProgress(downloadProgress:Double){
        print("progress percentage \(downloadProgress)");
        progressBar.setProgress(Float(downloadProgress), animated: true)
        progressPercentage.text = String(format: "%.0f",downloadProgress * 100);
    }
    
    func getLibDirectoryUrl() -> NSURL{
        let fileManager = NSFileManager.defaultManager();
        let libraryDirectory:NSArray = fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask);
        let libDirUrl:NSURL = libraryDirectory.firstObject as! NSURL;
        return libDirUrl;
    }
    
    func moveTempFileToLibLocation(tempFileLocation:NSURL) -> NSURL{
        let destinationURL:NSURL = getLibDirectoryUrl().URLByAppendingPathComponent("www.zip");
        let fileData = NSData(contentsOfURL: tempFileLocation);
        let fileDataString = NSString(data: fileData!, encoding: NSUTF8StringEncoding)
        print(fileDataString)
        fileData?.writeToURL(destinationURL, atomically: false);
        return destinationURL;
    }
    
    func unzipFile(zipFilePath:NSURL , unzipLocation:NSURL) -> String{
        let unzipped = SSZipArchive.unzipFileAtPath(
            zipFilePath.path,
            toDestination: unzipLocation.path);
        
        print("Unzip of file status \(unzipped) !!");
        print("location :: \(unzipLocation.path)");
        return unzipLocation.path!;
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("didFinishDownloadingToURL: \(location)")
        let zipFileLocation = moveTempFileToLibLocation(location);
        unzippedLocation = unzipFile(zipFileLocation, unzipLocation:getLibDirectoryUrl());
        moveToWebViewController(unzippedLocation);
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if(error == nil){
            print("Downloaded without error");
        }else{
            let alertController = UIAlertController(title: "LearnTron", message: "Error occurred during download", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title:"Dismiss",style:UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil);
            
            print("Error on downlodad \(error)")
        }
    }
}