//
//  GlobalEventTypeTableViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class GlobalEventTypeTableViewController: UITableViewController {
    
    var timelineData: NSMutableArray! = NSMutableArray()
    
    var eventType: String!
    
    var townNames: [String]!
    
    var doesExist = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        for object in timelineData {
            if townNames == nil {
                var townName = object.objectForKey("Location") as? String
                townNames.append(townName!)
            } else {
                for town in townNames {
                    if town == object.objectForKey("Location") as? String {
                        doesExist = true
                    }
                    
                }
                if doesExist == false {
                    townNames.append((object.objectForKey("Location") as? String)!)
                }
                doesExist = false
            }
        }

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

        return timelineData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityNames", forIndexPath: indexPath) as! FindACityTableViewCell
        
        var event = timelineData.objectAtIndex(indexPath.row) as! PFObject

        cell.cityName.text = event.objectForKey("Location") as? String

        return cell
    }
    
    func loadData() {
        timelineData.removeAllObjects()
        
        var findTimelineData = PFQuery(className: "NewSocialFeed")
        findTimelineData.whereKey("eventType", equalTo: eventType)
        
        findTimelineData.findObjectsInBackgroundWithBlock({
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


}
