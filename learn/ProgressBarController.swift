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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDownload();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startDownload(){
        if let urlObj = NSURL(string:url){
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: self,
                delegateQueue: NSOperationQueue.mainQueue())
            session.downloadTaskWithURL(urlObj).resume();
        }else{
            Commons.showOkAlert(self, msg:"Invalid Url !!", handler:alertOkHandler);
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        updateProgress(downloadProgress);
    }
    
    
    func moveToWebViewController(unzippedLocation:String){
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController;
        self.presentViewController(nextController, animated: true, completion: nil);
    }
    
    func updateProgress(downloadProgress:Double){
        progressBar.setProgress(Float(downloadProgress), animated: true)
        progressPercentage.text = String(format: "%.0f",downloadProgress * 100);
    }
    
    func moveTempFileToLibLocation(tempFileLocation:NSURL) -> NSURL{
        let destinationURL:NSURL = Commons.getLibDirectoryUrl().URLByAppendingPathComponent("www.zip");
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
       let zipFileLocation = moveTempFileToLibLocation(location);
        unzippedLocation = unzipFile(zipFileLocation, unzipLocation:Commons.getLibDirectoryUrl());
        moveToWebViewController(unzippedLocation);
    }
    
    func navigateToUrlEntryScreen(){
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("urlEntryViewController") as! ViewController;
        self.presentViewController(nextController, animated: true, completion: nil);
    }
    
    func alertOkHandler(action:UIAlertAction){
        navigateToUrlEntryScreen();
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil{
            Commons.showOkAlert(self, msg:"Error occurred during download !!", handler:alertOkHandler);
        }
    }
}