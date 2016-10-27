//
//  RsvpListTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/5/15.
//
//

import UIKit
import Parse

class RsvpListTableViewController: UITableViewController {
    
    var usernametoPass: String!
    
    var objectId: String!
    var objectName: String!
    
    var usernames: NSMutableArray! = NSMutableArray()
    
    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh Users List")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        refresh()

    }
    
    func refresh() {
        loadData()
        self.refresher.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rsvpListIdentifier", forIndexPath: indexPath) as! RsvpCellTableViewCell
        cell.username.alpha = 0
        
        var userToSearch = usernames[indexPath.row] as? String
        
        cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageToPost.clipsToBounds = true
        
        var queryProPic: PFQuery = PFUser.query()!
        queryProPic.whereKey("username", equalTo: userToSearch!)
        queryProPic.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if object.objectForKey("ProfilePic") != nil {
                        
                        object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                            
                            (data: NSData?, error: NSError?) -> Void in
                            
                            if error == nil {
                                let downloadedImage = UIImage(data: data!)
                                cell.imageToPost.image = downloadedImage
                            }
                            
                        })
                    } else {
                        cell.imageToPost.image = UIImage(named: "placeholder.jpg")
                    }
                }
            }
        })
        
        
        
        cell.username.text = userToSearch
        
        UIView.animateWithDuration(0.5, animations: {
            cell.username.alpha = 1
        })

        return cell
    }

    @IBAction func loadData() {
        usernames.removeAllObjects()
        
        var findUsers: PFQuery = PFQuery(className: "eventPosts")
        println(objectId)
        findUsers.whereKey("objectId", equalTo: objectId)
        
        findUsers.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    if object.objectForKey("rsvpList") as? [String] != nil {
                        
                        let tempArray = object.objectForKey("rsvpList") as! [String]
                        for user in tempArray  {
                            self.usernames.addObject(user)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        usernametoPass = usernames[indexPath.row] as? String
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rsvpDisplayProfile" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = usernametoPass
        }
    }
    
    
}
