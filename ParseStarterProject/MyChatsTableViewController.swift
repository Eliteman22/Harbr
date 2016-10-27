//
//  MyChatsTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/4/15.
//
//

import UIKit
import Parse

class MyChatsTableViewController: UITableViewController {
    
    var myEventsArray: NSMutableArray! = NSMutableArray()
    var eventIdsArray: NSMutableArray! = NSMutableArray()
    var objectIdToPass: String!
    
    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh chats")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        self.tabBarController?.tabBar.hidden = true

        refresh()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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

        return myEventsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myChatsIdentifier", forIndexPath: indexPath) as! MyChatsCellTableViewCell
        
        cell.eventName.alpha = 0
        
        var eventId = myEventsArray[indexPath.row] as! String
        eventIdsArray.addObject(eventId)
        var query = PFQuery(className: "eventPosts")
        query.whereKey("objectId", equalTo: eventId)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    cell.eventName.text = object.objectForKey("eventName") as? String
                    
                }
            }
        })
        
        UIView.animateWithDuration(0.5, animations: {
            cell.eventName.alpha = 1
        })
        


        return cell
    }

    @IBAction func loadData() {
        myEventsArray.removeAllObjects()
        
        var findEvents: PFQuery = PFUser.query()!
        findEvents.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        findEvents.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    if object.objectForKey("eventsAttending") as? [String] != nil {
                        let tempArray = object.objectForKey("eventsAttending") as! [String]
                        for event in tempArray {
                            self.myEventsArray.addObject(event)
                        }
                    } else {
                        self.alert("Alert", message: "You are not rsvp'd for any events")
                    }
                }
                
                
                let array: NSArray = self.myEventsArray.reverseObjectEnumerator().allObjects
                self.myEventsArray = array.mutableCopy() as? NSMutableArray
                
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
        objectIdToPass = eventIdsArray[indexPath.row] as? String
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myChatToGroupChat" {
            var svc = segue.destinationViewController as! GroupChatViewController
            svc.objectId = objectIdToPass
        }
    }

}
