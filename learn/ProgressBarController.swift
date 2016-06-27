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
    
    
    @IBAction func gotoWebView(sender: AnyObject) {
        print("Goto Web view now")
        print("Url to download from \(url)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start downloading the file from \(url)");
        let urlObj:NSURL = NSURL(string: url)!;
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let downloadTask = session.downloadTaskWithURL(urlObj)
        downloadTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("didResumeAtOffset: \(fileOffset)")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("downloadProgress: \(downloadProgress)")
    }
    
    func moveTempFileToDocumentLocation(tempFileLocation:NSURL){
        let fileManager = NSFileManager.defaultManager()
        let libraryDirectory:NSArray = fileManager.URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask);
        
        let libDirUrl:NSURL = libraryDirectory.firstObject as! NSURL;
        let destinationURL:NSURL = libDirUrl.URLByAppendingPathComponent("www.zip");
        
        let fileData = NSData(contentsOfURL: tempFileLocation);
        let fileDataString = NSString(data: fileData!, encoding: NSUTF8StringEncoding)
        print(fileDataString)
        fileData?.writeToURL(destinationURL, atomically: false)
        print("File moved to library    folder of app ");
        
        /*let unzipFolderLocation = libDirUrl.URLByAppendingPathComponent("www_exploded");
        SSZipArchive.unzipFileAtPath(destinationURL.absoluteString, toDestination: unzipFolderLocation.absoluteString);
        print("Unzip of file completed !!");*/
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("didFinishDownloadingToURL: \(location)")
        print(downloadTask)
        
        moveTempFileToDocumentLocation(location);
    }

    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if(error == nil){
            print("Downloaded without error");
        }else{
            print("Error on downlodad \(error)")
        }
    }
    
    
    

    
    
    

}