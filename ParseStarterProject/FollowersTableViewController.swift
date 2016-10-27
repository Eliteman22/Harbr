//
//  FollowersTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/31/15.
//
//

import UIKit
import Parse

class FollowersTableViewController: UITableViewController {
    
    var followers: NSMutableArray! = NSMutableArray()
    var profilePics: NSMutableArray! = NSMutableArray()
    var username: String!
    
    var usernameToSend: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var followersQuery: PFQuery = PFQuery(className: "followersClass")
        followersQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        followersQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) in
            
            
            if error == nil {
                for object in objects! {
                    println(object)
                    
                    if object.objectForKey("followers") != nil {
                        var followersArray = object.objectForKey("followers") as! NSMutableArray
                        self.followers = followersArray as NSMutableArray
                        
                        

                     
                    }
                    
                    let array: NSArray = self.followers.reverseObjectEnumerator().allObjects
                    self.followers = array.mutableCopy() as? NSMutableArray
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    
                }
            } else {
                self.displayAlert("Alert", message: "There is no one following you")
            }
            
            
        })
        

        
//        if PFUser.currentUser()!.objectForKey("Followers") != nil {
//            var followerNames = PFUser.currentUser()!.objectForKey("Followers") as! [String]
//            
//            for follower in followerNames {
//                followers.addObject(follower as String)
//                
//                
//            }
//        } else {
//            displayAlert("Sorry", message: "You do not currently have any followers")
//        }
        
        tableView.reloadData()
        
        self.tabBarController?.tabBar.hidden = true


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(followers.count)
        return followers.count
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        

            username = followers.objectAtIndex(indexPath.row) as! String
        
        println(username)
        
        return indexPath
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followersCell", forIndexPath: indexPath) as! FollowersCellTableViewCell
        if followers == nil {
            println("FUCK THIS SHIIIIIIIIT")
        } else {
            println("This gay shit should work")
        }
        
        cell.followerUsername.alpha = 0
        cell.followerProPic.alpha = 0
        
        if followers != nil {
        
            cell.followerUsername.text = followers.objectAtIndex(indexPath.row) as? String
            
            var query = PFUser.query()
            query!.whereKey("username", equalTo: (followers.objectAtIndex(indexPath.row) as? String)!)
            cell.followerProPic.layer.cornerRadius = cell.followerProPic.frame.height/2
            cell.followerProPic.clipsToBounds = true
            
            query!.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                for object in objects! {
                    if error == nil {
                        if object.objectForKey("ProfilePic") != nil {
                            
                            object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                                (data: NSData?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    let downloadedImage = UIImage(data: data!)
                                    cell.followerProPic.image = downloadedImage
                                    cell.followerProPic.contentMode = UIViewContentMode.ScaleAspectFit
                                }
                                
                                
                            })
                        } else {
                            cell.followerProPic.image = UIImage(named: "placeholder.jpg")
                            cell.followerProPic.contentMode = UIViewContentMode.ScaleAspectFit
                        }
                    }
                }
            })
            
            UIView.animateWithDuration(0.2, animations: {
                cell.followerUsername.alpha = 1
                cell.followerProPic.alpha = 1
            })
        }
        

        return cell
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myFollowersProfile" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = username
        }
    }

}
