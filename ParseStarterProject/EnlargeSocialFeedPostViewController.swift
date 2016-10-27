//
//  EnlargeSocialFeedPostViewController.swift
//  
//
//  Created by Flavio Lici on 8/5/15.
//
//

import UIKit
import Parse

class EnlargeSocialFeedPostViewController: UIViewController {
    
    var username: String!
    
    @IBOutlet var numberOfViews: UILabel!
    
    
    @IBOutlet var postedUsername: UILabel!
    
    @IBOutlet var userProPic: UIButton!
    
    var socialFeedImage: UIImage!
    
    var objectIdOfImage: String!

    @IBOutlet var imagePosted: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(objectIdOfImage)
        
        var queryNumViews = PFQuery(className: "SocialFeed")
        queryNumViews.whereKey("objectId", equalTo: objectIdOfImage)
        
        postedUsername.alpha = 1
        
        numberOfViews.alpha = 1
        
        postedUsername.text = username
        imagePosted.image = socialFeedImage
        
        imagePosted.contentMode = UIViewContentMode.ScaleAspectFill
        imagePosted.clipsToBounds = true
        
        
        
        queryNumViews.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    var views = [String]()
                    
                    println(object)
                    
                    if object.objectForKey("Views") == nil {
                        object.setObject(["1"], forKey: "Views")
                        println(object)
                        object.saveInBackground()
                        
                        self.numberOfViews.text = "1 View"
                    } else {
                        object.addObject("1", forKey: "Views")
                        views = (object.objectForKey("Views") as? [String])!
                        self.numberOfViews.text = "\(views.count) Views"
                        object.saveInBackground()
                    }
                    
                }
            } else {
                self.alert("Error", message: "There was an error loading the number of views")
                self.numberOfViews.text = "Views Not Available"
            }
        })
        
        
        userProPic.contentMode = UIViewContentMode.ScaleAspectFill
        userProPic.clipsToBounds = true
        userProPic.layer.cornerRadius = 10
        
        var query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    println(object)
                    if object.objectForKey("ProfilePic") != nil {
                        object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                            (data: NSData?, error: NSError?) -> Void in
                            
                            if error == nil {
                                let downloadedImage = UIImage(data: data!)
                                self.userProPic.setImage(downloadedImage, forState: .Normal)
                            } else {
                                self.userProPic.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal )
                            }
                        })
                    } else {
                        self.userProPic.setImage(UIImage(named: "placeholder.jpg"), forState: .Normal)
                    }
                }
            }
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fullSizeToProfile" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = username
        }
    }
    
    @IBAction func propicClick(sender: UIButton) {
        performSegueWithIdentifier("fullSizeToProfile", sender: self)
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
