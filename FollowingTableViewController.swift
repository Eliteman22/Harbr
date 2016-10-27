//
//  FollowingTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/31/15.
//
//

import UIKit
import Parse

class FollowingTableViewController: UITableViewController {
    
    var followerNames: [String]!
    
    var username: String!
    
    var followers: NSMutableArray! = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tabBarController?.tabBar.hidden = true

    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.dequeueReusableCellWithIdentifier("followingCell", forIndexPath: indexPath) as! followingCellTableViewCell
        username = followerNames[indexPath.row]
        
        return indexPath
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return followerNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followingCell", forIndexPath: indexPath) as! followingCellTableViewCell
        
        
        cell.usernameFollowing.alpha = 0
        cell.followingProPic.alpha = 0
        
        if followerNames != nil {
            
            var userToDisplay = followerNames[indexPath.row]
            println(userToDisplay)
            
            cell.usernameFollowing.text = userToDisplay
            
            var query = PFUser.query()!
            query.whereKey("username", equalTo: (userToDisplay))
            cell.followingProPic.layer.cornerRadius = cell.followingProPic.frame.height/2
            cell.followingProPic.clipsToBounds = true
            
            query.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                for object in objects! {
                    if error == nil {
                        if object.objectForKey("ProfilePic") != nil {
                            
                            println(object)
                            object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                                (data: NSData?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    let downloadedImage = UIImage(data: data!)
                                    cell.followingProPic.image = downloadedImage
                                    cell.followingProPic.contentMode = UIViewContentMode.ScaleAspectFit
                                }
                                
                                
                            })
                        } else {
                            cell.followingProPic.image = UIImage(named: "placeholder.jpg")
                            cell.followingProPic.contentMode = UIViewContentMode.ScaleAspectFit
                        }
                    }
                }
            })
            
            UIView.animateWithDuration(0.2, animations: {
                cell.usernameFollowing.alpha = 1
                cell.followingProPic.alpha = 1
            })
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let alertController = UIAlertController(title: "Wait", message: "Are you sure you want to delete \(followerNames[indexPath.row])?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {
                (action: UIAlertAction!) in
                
                PFUser.currentUser()!.removeObject(self.followerNames[indexPath.row], forKey: "Following")
                
                var userQuery = PFQuery(className: "followersClass")
                userQuery.whereKey("followers", equalTo: self.followerNames[indexPath.row])
                userQuery.findObjectsInBackgroundWithBlock({
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        for object in objects! {
                            let array: NSMutableArray = object.objectForKey("followerInfo") as! NSMutableArray
                            var index = array.indexOfObject("\(PFUser.currentUser()!.username!) has followed you")
                            println("\(index)")
                            object.removeObject(PFUser.currentUser()!.username!, forKey: "followers")
                            
                            let userTimesArray: NSMutableArray = object.objectForKey("followerTimes") as! NSMutableArray
                            userTimesArray.removeObjectAtIndex(index)
                            object.setObject(userTimesArray, forKey: "followerTimes")
                            
                            object.removeObject("\(PFUser.currentUser()!.username!) has followed you", forKey: "followerInfo")
                            
                            object.saveInBackground()
                        }
                    }
                })
                
                PFUser.currentUser()?.saveInBackground()
                PFUser.currentUser()?.fetch()
                
                self.loadData()
                tableView.reloadData()
                
                
            }))
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "followingProfileView" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = username
        }
    }
    
    @IBAction func loadData() {
        if PFUser.currentUser()!.objectForKey("Following") != nil {
            followerNames = PFUser.currentUser()!.objectForKey("Following") as! [String]
            for follower in followerNames {
                followers.addObject(follower)
            }
            
            println(followers)
            
        }
    }


}


