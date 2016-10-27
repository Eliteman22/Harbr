//
//  FacebookViewController.swift
//  
//
//  Created by Flavio Lici on 8/1/15.
//
//

import UIKit
import Parse

class FacebookViewController: UIViewController {
    
    var username: String!
    
    var facebookName: String!
    
    @IBOutlet var facebookWebView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("username", equalTo: username)
        
        userQuery!.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    var nameToPost = object.objectForKey("facebookName") as! String
                    self.self.facebookName = nameToPost
                    let url = NSURL(string: "https://facebook.com/\(self.facebookName)")
                    println(url!)
                    let requestObj = NSURLRequest(URL: url!)
                    self.facebookWebView.loadRequest(requestObj)
                    self.view.addSubview(self.facebookWebView)
                    
                }
            }
        })
        
        println(facebookName)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
