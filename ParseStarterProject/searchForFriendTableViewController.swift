//
//  searchForFriendTableViewController.swift
//  
//
//  Created by Flavio Lici on 8/5/15.
//
//

import UIKit
import Parse

class searchForFriendTableViewController: UITableViewController {
    
    var userNameSearched: String!
    
    var timelineData: NSMutableArray! = NSMutableArray()
    
    var usernameArray = [String]()
    
    var usernameToViewProfile: String!
    
    var isFollower = false
    
    var currentDate: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        


    }
    
    override func viewWillAppear(animated: Bool) {
        PFUser.currentUser()?.fetchInBackground()
        if timelineData == nil {
            alert("Alert", message: "There is no one with that name")
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let currentMonth = dateFormatter.stringFromDate(NSDate())
        
        let dateFormatterTime = NSDateFormatter()
        dateFormatterTime.timeStyle = .ShortStyle
        
        let currentTime = dateFormatterTime.stringFromDate(NSDate())
        
        currentDate = "\(currentMonth), \(currentTime)"

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
        return timelineData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchForFriendsIdentifier", forIndexPath: indexPath) as! searchForFriendsCellTableViewCell

        

        let event: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.imageToPost.alpha = 0
        cell.friendsName.alpha = 0
        cell.isAFollower.alpha = 0
        
        if (timelineData != nil) && (event.objectForKey("username") as? String != PFUser.currentUser()!.username!) {
        
        cell.friendsName.text = event.objectForKey("username") as? String
        usernameArray.append((event.objectForKey("username") as? String)!)
        if event.objectForKey("ProfilePic") != nil {
            event.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage: UIImage = UIImage(data: data!)!
                    cell.imageToPost.image = downloadedImage
                    cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
                    cell.imageToPost.clipsToBounds = true
                    cell.imageToPost.layer.cornerRadius = cell.imageToPost.frame.height/2
                } else {
                    self.alert("Error", message: "There was an error retrieving images for the users")
                }
            })
        } else {
            cell.imageToPost.image = UIImage(named: "placeholder.jpg")
            cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            cell.imageToPost.clipsToBounds = true
            cell.imageToPost.layer.cornerRadius = cell.imageToPost.frame.height/2
        }
        }
        
        var followersArray: [String]!
        
        if PFUser.currentUser()!.objectForKey("Following") != nil {
        
        followersArray = PFUser.currentUser()!.objectForKey("Following") as? [String]
            
            
        if followersArray != nil {
            for follower in followersArray! {
                if follower == event.objectForKey("username") as? String {
                    isFollower = true
                }
            }
        } else {
            alert("Error", message: "This user does not exist")
            }
    }
        
        if isFollower == true {
            cell.isAFollower.setImage(UIImage(named: "checked_2.png"), forState: .Normal)
        } else {
            cell.isAFollower.setImage(UIImage(named: "CheckGray.jpg"), forState: .Normal)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            cell.friendsName.alpha = 1
            cell.imageToPost.alpha = 1
            cell.isAFollower.alpha = 1
        })
        

        return cell
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loadData() {
        timelineData.removeAllObjects()
        
        var findTImeLineData: PFQuery = PFUser.query()!
        findTImeLineData.whereKey("username", containsString: userNameSearched)
        
        findTImeLineData.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    @IBAction func followButton(sender: UIButton) {
        
        if sender.imageView?.image == UIImage(named: "checked_2.png") {
            var alert = UIAlertController(title: "Alert", message: "Are you sure you want to unfollow this user", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {
                (action) -> Void in
                
                var usernameAtPos = ""
                
                var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
                if let indexPath = self.tableView.indexPathForRowAtPoint(position) {
                    
                    usernameAtPos = self.usernameArray[indexPath.row]
                }
                
                PFUser.currentUser()?.removeObject(usernameAtPos, forKey: "Following")
                PFUser.currentUser()?.saveInBackground()
                
                var query: PFQuery = PFQuery(className: "followersClass")
                query.whereKey("username", equalTo: usernameAtPos)
                
                query.findObjectsInBackgroundWithBlock( {
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
                        
                        } else {
                            self.alert("Error", message: "There was an error unfollowing the user")
                    }
                })
                
                sender.setImage(UIImage(named: "CheckGray.jpg"), forState: .Normal)
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            sender.setImage(UIImage(named: "checked_2.png"), forState: .Normal)
            
            var usernameAtPos = ""
            
            var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(position) {
                
                usernameAtPos = self.usernameArray[indexPath.row]
                println(usernameAtPos)
            }
            if !usernameAtPos.isEmpty {
                if PFUser.currentUser()?.objectForKey("Following") != nil {
                    PFUser.currentUser()?.objectForKey("Following")?.addObject(usernameAtPos)
                    PFUser.currentUser()?.saveInBackground()
                } else {
                    PFUser.currentUser()!["Following"] = [usernameAtPos]
                    PFUser.currentUser()?.saveInBackground()
                }
            } else {
                alert("Error", message: "Could not follow user, please try again later")
            }
            
            var query: PFQuery = PFQuery(className: "followersClass")
            query.whereKey("username", equalTo: usernameAtPos)
            
            query.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    for object in objects! {
                        object.addObject(PFUser.currentUser()!.username!, forKey: "followers")
                        object.objectForKey("followerInfo")!.addObject("\(PFUser.currentUser()!.username!) has followed you")
                        object.objectForKey("followerTimes")!.addObject(self.currentDate)
                        object.saveInBackground()
                        self.alert("Congrats", message: "You have followed \(usernameAtPos)")
                        
                    }
                } else {
                    self.alert("Error", message: "There was an error following the user")
                }
            })
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFriendProfile" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = usernameToViewProfile
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let event: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        usernameToViewProfile = event.objectForKey("username") as? String
        
        return indexPath
    }

}
