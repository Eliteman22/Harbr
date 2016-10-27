//
//  EventFeedTableViewController.swift
//  
//
//  Created by Flavio Lici on 6/30/15.
//
//

import UIKit
import Parse
import CoreLocation
import MapKit

class EventFeedTableViewController: UITableViewController, CLLocationManagerDelegate, UITableViewDelegate {
    
    var objectId: String!
    
//    var refresher: UIRefreshControl!
    
    var objectIdArray = [""]
    var objectNamesArray = [""]
    
    var timer = NSTimer()
    
    var searchActive: Bool = false
    
    var timeLineData: NSMutableArray! = NSMutableArray()
    
    var hasVotedCount: Int = Int()
    
    var count = Int()
    
    var animationCount: Float = 0
    
    var objectIdForGroupChat: String!
    
    var shouldUpdateAnimationTime: Bool = false
    
    var eventIsReal: Bool! = true
    
    var userLocationFromLocationManager: CLLocation!
    
    var currentDate: String!
    
    var compareDate: String!
    
    var isTooFar: Bool! = false
    
    var objectNameForGroupChat: String!
    
    @IBOutlet var rsvpEdit: UIButton!
    
    var flashingColorsNum: Int!
    
    var locationManager = CLLocationManager()

    
    var eventOwner: String!
    
    var boat: Animation2View!
    
    var userLat: CLLocationDegrees!
    
    var userLon: CLLocationDegrees!
    
    
    
    func updateTime() {
        
        if let refresher = refreshControl {
            
            if animationCount > 0.6 || animationCount == 0{
                animationCount = 0
                
                refresher.backgroundColor = UIColorFromRGB("cfe3ff", alpha: 1.0)
                
            } else {
                
                if animationCount == 0.2 {
                    refresher.backgroundColor = UIColorFromRGB("ffcece", alpha: 1.0)
                } else if animationCount == 0.4 {
                    refresher.backgroundColor = UIColorFromRGB("cfffd4", alpha: 1.0)
                } else if animationCount == 0.6 {
                    refresher.backgroundColor = UIColorFromRGB("fffccf", alpha: 1.0)
                }
                
                
                
            }
        }
        
        animationCount = animationCount + 0.2
        
        
        
    }
    
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        locationManager = CLLocationManager()
//        locationManager!.requestWhenInUseAuthorization()
//        
//        return true
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView(frame:
            CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
    
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        PFUser.currentUser()?.fetchInBackground()
        

        self.view.addSubview(view)
        
        let compareDateFormatter = NSDateFormatter()
        compareDateFormatter.dateStyle = .ShortStyle
        compareDate = compareDateFormatter.stringFromDate(NSDate())
    
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        currentDate = dateFormatter.stringFromDate(NSDate())
        
        objectIdArray.removeAtIndex(0)
        objectNamesArray.removeAtIndex(0)
        
        self.navigationController?.navigationBarHidden = false
        
            var navigationBarAppearance = UINavigationBar.appearance()
        
      
            self.navigationController?.navigationBar.topItem?.title = "harbr"

        if let refresher = refreshControl {
            refresher.tintColor = UIColor.clearColor()
            refresher.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
            
            
            
            boat = Animation2View(frame: refresher.bounds)
            boat.contentMode = UIViewContentMode.ScaleAspectFill
            
            
            
            refresher.addSubview(boat)
      
            println("TimelineData: \(timeLineData)")
            println("TimelineData Count: \(timeLineData.count)")
            

            
            
        }
        

        

        
    
        
//        refresher = UIRefreshControl()
//        refresher.tintColor = UIColor.clearColor()
//        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        
//        boat = Animation2View(frame: refresher.bounds)
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        
//        boat.contentMode = .ScaleAspectFit
//        
//        
//        refresher.addSubview(boat)
//        self.tableView.addSubview(refresher)
//        
//        refresh()
        
    }
    

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if refreshControl!.refreshing {
            
            
            
            boat.removeThresholdAnimation()
            boat.addUntiltedAnimation()
            
            boat.layer.beginTime = CACurrentMediaTime()
            boat.layer.speed = 0
            
            shouldUpdateAnimationTime = true
            
        }
        
        var offsetY = self.tableView.contentOffset.y
        for cell in self.tableView.visibleCells() as! [EventCellTableViewCell] {
            let x = cell.imageToPost.frame.origin.x
            let w = cell.imageToPost.bounds.width
            let h = cell.imageToPost.bounds.height
            var y = ((offsetY - cell.frame.origin.y) / h) * 25
            cell.imageToPost.frame = CGRectMake(x, y, w, h)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let refresher = refreshControl {
            
            
            
            let pullAmount = max(0.0, -refresher.frame.origin.y - 30)
            let ratio = pullAmount / 130
            
            if shouldUpdateAnimationTime && pullAmount > 0.0 {
                boat.layer.timeOffset = Double(3.0 * ratio)
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        println("Should grab")
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        userLat = latitude
        userLon = longitude
        
        locationManager.stopUpdatingLocation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)

        
        self.navigationController?.navigationBar.topItem?.title = "harbr"
        
        
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "FLW Script", size: 45)!,  NSForegroundColorAttributeName: UIColorFromRGB("ED9F50", alpha: 1.0)]
        
        
        
        if checkIfDay(currentDate) {
            self.tabBarController?.tabBar.backgroundImage = nil
            self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        } else {
            self.tabBarController?.tabBar.backgroundImage = UIImage(named: "DATNEWNEWBOTTOM.png")
        }
        
        
        loadData()
        


    }
    
    
    override func viewDidAppear(animated: Bool) {
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timeLineData.count != 0 {
            return timeLineData.count
        } else {
            return 0
        }
        
       
    }
    
    func checkIfDay(time: String) -> Bool {
        
        var fullName = time
        let fullNameArr = fullName.componentsSeparatedByString(":")
        
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
        
        if (firstName.toInt()! > 6) && (firstName.toInt()! <= 19) {
            return true
        } else {
            return false
        }
        
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("eventFeedIdentifier", forIndexPath: indexPath) as! EventCellTableViewCell
        


        
        if timeLineData.count >= indexPath.row && timeLineData.count > 0 {
        
//        if indexPath.row <= timeLineData.count + 1 {
        var event: PFObject! = self.timeLineData.objectAtIndex(indexPath.row) as! PFObject
        
        
        
        
        
        cell.eventName.alpha = 0
        cell.eventTIme.alpha = 0
        cell.eventDescription.alpha = 0
        cell.imageToPost.alpha = 0
            
        cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            
            
        let eventType = event.objectForKey("date") as! String
            
            
            
            println(eventType)
            println(compareDate)
            
            
            

        
        cell.eventType.text = event.objectForKey("eventType") as? String
            
            if event.objectForKey("venueName") != nil {
                cell.venueName.text = event.objectForKey("venueName") as? String
                cell.venueId.text = event.objectForKey("venueId") as? String
            } else {
                cell.venueName.alpha = 0
                cell.waypoint.alpha = 0
                cell.venueName.userInteractionEnabled = false
            }
            
        
        let eventName = event.objectForKey("eventName") as? String
        
            if eventName != nil {
                cell.eventName.text = "  \(eventName!)"
                

            } else {
                cell.eventName.alpha = 0
            }
        cell.imageToPost.clipsToBounds = true
        let eventDescriptions = event.objectForKey("description") as? String
            
            if eventDescriptions != nil {
                cell.eventDescription.text = "   \(eventDescriptions!)"
                
                
            } else {
                cell.eventDescription.alpha = 0
            }
            if checkIfDay(currentDate) {
                cell.nightShade.alpha = 0
                cell.eventType.backgroundColor = UIColor.whiteColor()
            } else {
                cell.eventType.backgroundColor = UIColorFromRGB("3e3e3e", alpha: 1.0)
                cell.eventType.textColor = UIColor.whiteColor()
    
            }
            
            
        
        let eventTime = event.objectForKey("eventTime") as? String
            if event.objectForKey("date") != nil {
                
                let eventDate = event.objectForKey("date") as? String
                
                cell.eventDate.text = "  \(eventDate!)"
            } else {
                cell.eventDate.text = "N/A"
            }
        cell.eventTIme.text = "  \(eventTime!)"
        
        
        
        objectIdArray.append(event.objectId!)
        objectNamesArray.append(event.objectForKey("eventName") as! String)
    
        
        if (event.objectForKey("imageFIle")) != nil {
            
            event.objectForKey("imageFIle")!.getDataInBackgroundWithBlock({
            
            (data: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                let downloadedImage = UIImage(data: data!)
            cell.imageToPost.image = downloadedImage
            cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            } else {
                
                }
            
            })
            
            
            
            } else {
            cell.imageToPost.image = UIImage(named: "placeholder.jpg")
        }
                
                UIView.animateWithDuration(0, animations: {
                    cell.eventName.alpha = 1
                    cell.eventTIme.alpha = 1
                    cell.eventDescription.alpha = 1
                    cell.imageToPost.alpha = 1
                    
                })
            
    }
        
        
        
  
        //}
        
        return cell
    }
    
    
    func loadData() {
        timeLineData.removeAllObjects()
        
        var findTImeLineData: PFQuery = PFQuery(className: "eventPosts")
        findTImeLineData.addDescendingOrder("date")
        
        findTImeLineData.findObjectsInBackgroundWithBlock ( {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    var event: PFObject! = object as! PFObject
                    println("userLon: \(self.userLon)")
                    println("userLat: \(self.userLat)")
                    
                    if self.userLon != nil && self.userLat != nil && event.objectForKey("lat") != nil && event.objectForKey("lon") != nil {
                        let location1: CLLocation = CLLocation(latitude: self.userLat, longitude: self.userLon)
                        let location2: CLLocation = CLLocation(latitude: (event.objectForKey("lat") as? CLLocationDegrees)!, longitude: (event.objectForKey("lon") as? CLLocationDegrees)!)
                        println("location1: \(location1)")
                        println("location2: \(location2)")
                        
                        let distance = location2.distanceFromLocation(location1)
                        
                        let distanceInKm = distance / 1000
                        
                        println("distanceInKm: \(distanceInKm)")
                        
                        let distanceInMiles = distanceInKm * 0.6
                        
                        println("distance: \(distanceInMiles)")
                        
                        if distanceInMiles > 50.0 {
                            self.isTooFar = true
                        }
                        
                        let eventType = event.objectForKey("date") as! String
                        
                        let dateFormatter2 = NSDateFormatter()
                        dateFormatter2.dateStyle = .ShortStyle
                        let eventTypeReal = dateFormatter2.dateFromString(eventType)
                        let currentDateToCompare = dateFormatter2.dateFromString(self.compareDate)
                        
                        if eventTypeReal!.isLessThanDate(currentDateToCompare!) {
                            self.eventIsReal = false
                            
                        }
                        
                        println("\(self.isTooFar)")
                        println("\(self.eventIsReal)")
                        
                        if self.isTooFar == false && self.eventIsReal == true {
                            println("SHOULD FUCKING WORK")
                            self.timeLineData.addObject(object)
                            println("ADDED OBJECT")
                        } else if self.eventIsReal == false {
                            println("FUCKING DOESNT WORK")
                            event.deleteInBackground()
                        }
                        self.isTooFar = false
                     
                    }
                
                }
                if self.timeLineData?.count == 0
                {
                    
                    println("No Data")
                    
                    self.performSegueWithIdentifier("noEventsInArea", sender: self)
                }
                let array: NSArray = self.timeLineData.reverseObjectEnumerator().allObjects
                self.timeLineData = array.mutableCopy() as? NSMutableArray
                println("PreTimelineData: \(self.timeLineData)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
                
                
                
                
            }
            
            
        })
        
        
    }

    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        var scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    @IBAction func rsvp(sender: UIButton) {
        
        count = 0
        let view = sender.superview!
        let newcell = view.superview! as! EventCellTableViewCell
        
        let indexPath = tableView.indexPathForCell(newcell)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventFeedIdentifier", forIndexPath: indexPath!) as! EventCellTableViewCell
        
        let event: PFObject = self.timeLineData.objectAtIndex(indexPath!.row) as! PFObject
        var eventObjectId = event.objectId!
        var eventObjectName = event.objectForKey("eventName") as? String
        objectNameForGroupChat = eventObjectName
        objectIdForGroupChat = event.objectId!
        println(eventObjectId)
        
        
        var query = PFQuery(className: "eventPosts")
        query.whereKey("objectId", equalTo: eventObjectId)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            
            if error == nil {
                for object in objects! {
                    let usersWhoRsvpd = object.objectForKey("rsvpList") as? [String]
                    if usersWhoRsvpd != nil {
                        for user in usersWhoRsvpd! {
                            println(user)
                            if user == PFUser.currentUser()!.username! {
                                self.count++
                            }
                        }
                        
                        if self.count == 0 {
                            
                            var submitAlert = UIAlertController(title: "Confirm", message: "Please confirm you would like to RSVP", preferredStyle: UIAlertControllerStyle.Alert)
                            submitAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {
                                
                                (action: UIAlertAction!) in
                                if object.objectForKey("rsvpList") != nil {
                                        println("Should rsvp")
                                    println(object.objectForKey("rsvpList") as? [String])
                                    object.objectForKey("rsvpList")!.addObject(PFUser.currentUser()!.username!)
                                      
                                    object.saveInBackgroundWithBlock({ (success, error) -> Void in
                                        if error == nil {
                                            self.displayAlert("Error", message: "The username or email has already been taken")
                                        } else {
                                            println(error)
                                        }
                                    })
                        
                                } else {
                                    object.setObject([PFUser.currentUser()!.username!], forKey: "rsvpList")
                                    object.saveInBackground()
                                }
                                
                                if PFUser.currentUser()!.objectForKey("eventsAttending") != nil {
                                    PFUser.currentUser()!.objectForKey("eventsAttending")!.addObject(eventObjectId)
                                    
                                } else {
                                    PFUser.currentUser()!.setObject([eventObjectId], forKey: "eventsAttending")
                                    
                                }
                                
                                
                                
                                if PFUser.currentUser()!.objectForKey("eventsAttendingName") != nil {
                                    PFUser.currentUser()?.objectForKey("eventsAttendingName")!.addObject(eventObjectName!)
                                    
                                } else {
                                    PFUser.currentUser()!.setObject([eventObjectName!], forKey: "eventsAttendingName")
                                    
                                }
                                
                                
                                
                                if PFUser.currentUser()!.objectForKey("Points") == nil {
                                    PFUser.currentUser()!.setObject(5, forKey: "Points")
                                    
                                } else {
                                    var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
                                    var newScore: Int = currentPoints! + 5
                                    PFUser.currentUser()!.setObject(newScore, forKey: "Points")
                                    
                                }
                            
                                PFUser.currentUser()?.saveInBackground()
                                
                                self.displayAlert("Congrats", message: "You have RSVP'd")
                                
                                
                            }))
                            submitAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(submitAlert, animated: true, completion: nil)
                            
                            
                        } else {
                            self.displayAlert("Alert", message: "You have already rsvpd")
                        }

                       
                    } else {
                        self.displayAlert("Error", message: "There was an error while rsvping")
                        
                    }
                    
                }
            } else {
                self.displayAlert("Error", message: "There was an error while rsvping")
                println(error)
            }
            
        })
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let currentMonth = dateFormatter.stringFromDate(NSDate())
        
        let dateFormatterTime = NSDateFormatter()
        dateFormatterTime.timeStyle = .ShortStyle
        
        let currentTime = dateFormatterTime.stringFromDate(NSDate())
        
        let currentDate = "\(currentMonth), \(currentTime)"
        
        var rsvpUpdateQuery = PFQuery(className: "followersClass")
        rsvpUpdateQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        rsvpUpdateQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {

                    var followersArray = object.objectForKey("followers") as! [String]
                    
                    for follower in followersArray {
                        var followersSearch = PFQuery(className: "followersClass")
                        followersSearch.whereKey("username", equalTo: follower)
                        followersSearch.findObjectsInBackgroundWithBlock({
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                for object in objects! {
                                    if object.objectForKey("followerInfo") != nil {
                                        object.addObject("\(PFUser.currentUser()!.username!) has RSVPd for the event \(eventObjectName)", forKey: "followerInfo")
                                    } else {
                                        object.setObject("\(PFUser.currentUser()!.username!) has RSVPd for the event \(eventObjectName)", forKey: "followerInfo")
                                    }
                                    
                                    if object.objectForKey("followerTimes") != nil {
                                        
                                        object.addObject(currentDate, forKey: "followerTimes")
                                        
                                    } else {
                                        object.setObject(currentDate, forKey: "followerTimes")
                                        
                                    }
                                }
                                
                                object.saveInBackground()
                            }
                                
                            
                        })
                    }
                    
                }
            }
        })

        
    }
    
    
//    @IBAction func likePost(sender: UIButton) {
//        
//        hasVotedCount = 0
//        
//        let view = sender.superview!
//        let newcell = view.superview! as! EventCellTableViewCell
//        
//        let indexPath = tableView.indexPathForCell(newcell)
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("eventFeedIdentifier", forIndexPath: indexPath!) as! EventCellTableViewCell
//        
//        let event: PFObject = self.timeLineData.objectAtIndex(indexPath!.row) as! PFObject
//        
//        let voteObjectId = event.objectId
//        
//        
//        
//        var query = PFQuery(className: "eventPosts")
//        query.whereKey("objectId", equalTo: voteObjectId!)
//        
//        query.findObjectsInBackgroundWithBlock({
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                for object in objects! {
//                    let usersWhoVotedArray = object.objectForKey("usersVoted") as? [String]
//                    if usersWhoVotedArray != nil {
//                        for user in usersWhoVotedArray! {
//                            if (user) == PFUser.currentUser()!.username! {
//                                self.hasVotedCount++
//                            }
//                        }
//                        
//                        if self.hasVotedCount == 0 {
//                            var currentVote = usersWhoVotedArray!.count
//                            var newVote = "\(currentVote++)"
//                            if object.objectForKey("numVotes") != nil {
//                                object.objectForKey("numVotes")!.addObject("1")
//                                cell.numberOfVotes.text = newVote
//                                object.objectForKey("usersVoted")!.addObject(PFUser.currentUser()!.username!)
//                                object.saveInBackground()
//                                self.loadData()
//                            } else {
//                                object.setObject(["1"], forKey: "numVotes")
//                                cell.numberOfVotes.text = "1"
//                                object.objectForKey("usersVoted")!.addObject(PFUser.currentUser()!.username!)
//                                object.saveInBackground()
//                                self.loadData()
//                            }
//                            
//                        } else {
//                            self.displayAlert("Error", message: "You have already voted")
//                        }
//                    }
//                }
//            }
//            
//        })
//        
//    }
    
    var eventLocation = ""
    var eventName = ""
    
    func refresh() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
        shouldUpdateAnimationTime = false
        boat.removeUntiltedAnimation()
        boat.addThresholdAnimation()
        boat.layer.speed = 1
        boat.layer.beginTime = CACurrentMediaTime()
        boat.layer.timeOffset = 0
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            if let refresher = self.refreshControl {
                

                self.loadData()
                refresher.endRefreshing()
                self.timer.invalidate()
               
            }
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event: PFObject = self.timeLineData.objectAtIndex(indexPath.row) as! PFObject
        objectId = event.objectId
        eventLocation = event.objectForKey("location") as! String
        eventName = event.objectForKey("eventName") as! String
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moreInfoSegue" {
            var svc = segue.destinationViewController as! MoreInfoViewController
            svc.objectId = objectId
            svc.eventLocation = eventLocation
            svc.eventName = eventName
            svc.eventOwner = eventOwner
        } else if segue.identifier == "rsvpSegue" {
            var svc = segue.destinationViewController as! GroupChatViewController
            svc.objectId = objectIdForGroupChat
            svc.objectName = eventName
            print(objectId)
            print(eventName)
        }
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let event: PFObject = self.timeLineData.objectAtIndex(indexPath.row) as! PFObject
        objectId = event.objectId
        eventLocation = event.objectForKey("location") as! String
        eventName = event.objectForKey("eventName") as! String
        eventOwner = event.objectForKey("eventOwner") as! String
        
        return indexPath
    }


    
   func didRecieveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    

}
extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
//    func isEqualToDate(dateToCompare : NSDate) -> Bool
//    {
//        //Declare Variables
//        var isEqualTo = false
//        
//        //Compare Values
//        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame
//        {
//            isEqualTo = true
//        }
//        
//        //Return Result
//        return isEqualTo
//    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    
}