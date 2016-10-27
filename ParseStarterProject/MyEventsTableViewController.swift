//
//  MyEventsTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/4/15.
//
//

import UIKit
import Parse

class MyEventsTableViewController: UITableViewController {
    
    var objectIdToPass: String!
    
    var locationToPassArray: NSMutableArray! = NSMutableArray()
    
    
    var nameToPassArray: NSMutableArray! = NSMutableArray()
    
    var locationToPassSingle: String!
    
    var nameToPassSingle: String!
    
    var findEventOwnerArray: NSMutableArray! = NSMutableArray()
    var refresher: UIRefreshControl!
    
    var myEventsArray: NSMutableArray! = NSMutableArray()
    
    var eventOwnerToPass: String!
    
    let eventNamesArray: NSMutableArray! = NSMutableArray()
    
    var eventStillExists: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PFUser.currentUser()?.fetchInBackground()
        var eventListQuery: PFQuery = PFQuery(className: "eventPosts")
        eventListQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println(objects)
                for object in objects! {
                    var objectIdForEvent = object.objectId!!
                    println(objectIdForEvent)
                    self.eventNamesArray.addObject(objectIdForEvent)
                    println(objectIdForEvent)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            } else {
                println("You fucked up nigga")
            }
            
            
            
        })
        
        println(eventNamesArray.count)
        refresher = UIRefreshControl()

        
        self.tabBarController?.tabBar.hidden = true

        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        loadData()
        self.refresher.endRefreshing()
    }
    
 
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return myEventsArray.count
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        PFUser.currentUser()?.fetchInBackground()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myEventsIdentifier", forIndexPath: indexPath) as! MyEventsCellTableViewCell
        
        cell.userInteractionEnabled = false

        
        if myEventsArray.count >= indexPath.row && myEventsArray.count > 0 {
        
        var eventId = myEventsArray[indexPath.row] as! String
            
            
            for event in eventNamesArray {
                if event as! String == eventId {
                    eventStillExists = true
                    println("It is true")
                } else {
                    eventStillExists = false
                }
            }
        
        if eventStillExists == true {
            
            println("goes into post")
            

        
        
        
        cell.eventName.alpha = 0
        cell.numberOfPeopleAttending.alpha = 0
        cell.address.alpha = 0
        cell.date.alpha = 0
        cell.time.alpha = 0
        
            var query = PFQuery(className: "eventPosts")
            query.addDescendingOrder("date")
            query.whereKey("objectId", equalTo: eventId)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    
                    
                    
                    var nameOfEvent = object.objectForKey("eventName") as? String
                    
                    cell.eventName.text = "\(nameOfEvent!)"
                    cell.numberOfPeopleAttending.text = String((object.objectForKey("rsvpList") as! [String]).count) + " attending"
                    cell.address.text = object.objectForKey("location") as? String
                    cell.date.text = object.objectForKey("date") as? String
                    cell.time.text = object.objectForKey("eventTime") as? String
                    
                    if object.objectForKey("venueName") != nil {
                        cell.venueName.text = object.objectForKey("venueName") as? String
                    } else {
                        cell.venueName.alpha = 0
                        cell.venueName.userInteractionEnabled = false
                    }
                    
                    self.locationToPassArray.addObject(object.objectForKey("location") as! String)
                    self.nameToPassArray.addObject(object.objectForKey("eventName") as! String)
                }
                
                
            }
        })
        
        UIView.animateWithDuration(0.5, animations: {
            cell.eventName.alpha = 1
            cell.numberOfPeopleAttending.alpha = 1
            cell.address.alpha = 1
            cell.date.alpha = 1
            cell.time.alpha = 1
        })
            } else {
                
                var eventId = myEventsArray[indexPath.row] as! String
                
                println("Should be deleting")
            
            if myEventsArray.count > 0 && eventNamesArray.count > 0 {
                myEventsArray.removeObjectAtIndex(indexPath.row)
                eventNamesArray.removeObjectAtIndex(indexPath.row)
                PFUser.currentUser()?.removeObject(eventId, forKey: "eventsAttending")
                PFUser.currentUser()?.saveInBackground()
                loadData()
                self.tableView.reloadData()
            } else {
                println("didnt erase")
                println("myEvents: \(myEventsArray.count)")
                println("eventNames: \(eventNamesArray.count)")
            }
            
            
            }
        }

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
                        self.alert("Alert", message: "You have not rsvp'd for any events")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myEventsToMoreInfo" {
            var svc = segue.destinationViewController as! MoreInfoViewController
           svc.objectId = objectIdToPass
           svc.eventLocation = locationToPassSingle
            svc.eventName = nameToPassSingle
            
            svc.eventOwner = "flaviolici"

            

            
        }
        
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        

        
        let cell = tableView.dequeueReusableCellWithIdentifier("myEventsIdentifier", forIndexPath: indexPath) as! MyEventsCellTableViewCell
        
        objectIdToPass = myEventsArray[indexPath.row] as! String

        println(objectIdToPass)
        locationToPassSingle = locationToPassArray.objectAtIndex(indexPath.row) as! String
        println(locationToPassSingle)
        nameToPassSingle = nameToPassArray.objectAtIndex(indexPath.row) as! String
        println(nameToPassSingle)
        
        findEventOwnerArray.removeAllObjects()
        
        var getEventOwner = PFQuery(className: "eventPosts")
        getEventOwner.whereKey("objectId", equalTo: objectIdToPass)
        getEventOwner.findObjectsInBackgroundWithBlock({
            
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.findEventOwnerArray.addObject(object)
                }
            }
        })
        
        

        

        
        return indexPath
    }


}
