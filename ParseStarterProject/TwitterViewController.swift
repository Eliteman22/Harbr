//
//  TwitterViewController.swift
//  
//
//  Created by Flavio Lici on 8/1/15.
//
//

import UIKit
import Parse

class TwitterViewController: UIViewController {
    
    @IBOutlet var twitterWebView: UIWebView!
    
    var username: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var twitterName = ""
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("username", equalTo: username)
        
        userQuery?.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    twitterName = (object.objectForKey("twitterName") as? String)!
                    
                    let url = NSURL(string: "https://twitter.com/\(twitterName)")
                    let requestObj = NSURLRequest(URL: url!)
                    self.twitterWebView.loadRequest(requestObj)
                    self.view.addSubview(self.twitterWebView)
                }
            }
            
        })
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
