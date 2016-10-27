//
//  RsvpDisplayProfileViewController.swift
//  
//
//  Created by Flavio Lici on 7/5/15.
//
//

import UIKit
import Parse

class RsvpDisplayProfileViewController: UIViewController {
    
    @IBOutlet var fullName: UILabel!
    
    @IBOutlet var userProPic: UIImageView!
    
    var username: String!

    @IBOutlet var Bio: UITextView!
    
    @IBOutlet var Followers: UILabel!
    
    @IBOutlet var Following: UILabel!
    
    
    
    var isFollowing: Bool = false
    
    
    @IBOutlet var followButton: UIButton!
    
    @IBOutlet var twitterButtonShows: UIButton!
    
    @IBOutlet var facebookButtonShows: UIButton!
    
    
    @IBOutlet var userPoints: UILabel!
    
    var pointsToPost: Int!
    
    var currentDate: String!
    
    
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.text = ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        
        let currentMonth = dateFormatter.stringFromDate(NSDate())
        
        let dateFormatterTime = NSDateFormatter()
        dateFormatterTime.timeStyle = .ShortStyle
        
        let currentTime = dateFormatterTime.stringFromDate(NSDate())
        
        currentDate = "\(currentMonth), \(currentTime)"

        
        self.tabBarController?.tabBar.hidden = true

        
        var userSocialQuery = PFUser.query()
        userSocialQuery!.whereKey("username", equalTo: username)
        
        followButton.layer.cornerRadius = 10
        followButton.clipsToBounds = true
        
        userSocialQuery!.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    if object.objectForKey("twitterName") == nil {
                        self.twitterButtonShows.alpha = 0
                        self.twitterButtonShows.enabled = false
                    }
                    
                    if object.objectForKey("facebookName") == nil {
                        self.facebookButtonShows.alpha = 0
                        self.facebookButtonShows.enabled = false
                    }
                }
            }
        })
        
        var userInfo = PFUser.query()
        userInfo!.whereKey("username", equalTo: username)
        
        userInfo?.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    
                    if object.objectForKey("Following") != nil {
                        var followingArray = object.objectForKey("Following") as! [String]
                        self.Following.text = "\(followingArray.count)"
                    } else {
                        self.Following.text = "0"
                    }
                    
                    if object.objectForKey("Points") != nil {
                       self.pointsToPost = object.objectForKey("Points") as! Int
                        self.userPoints.text = "\(self.pointsToPost)"
                    } else {
                        self.userPoints.text = "0"
                    }
                    
                }
            }
        })
        
        var followersQuery = PFQuery(className: "followersClass")
        followersQuery.whereKey("username", equalTo: username)
        followersQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    
                    if object.objectForKey("followers") != nil {
                        var followersList = object.objectForKey("followers") as! [String]
                        var followersCount = followersList.count
                        
                        self.Followers.text = "\(followersCount)"
                    } else {
                        self.Followers.text = "0"
                    }
                    
                }
            }
        })
        
        var followingList = PFUser.currentUser()!.objectForKey("Following") as! [String]
        for follower in followingList {
            if (follower as String) == username {
                isFollowing = true
            }
        }
        
        if isFollowing == true {
            followButton.backgroundColor = UIColorFromRGB("238923", alpha: 1)
            followButton.setTitle("Following", forState: .Normal)
        } else {
            followButton.backgroundColor = UIColorFromRGB("3f76a5", alpha: 1)
            followButton.setTitle("Follow", forState: .Normal)
        }
        
        
        reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadData() {
        var findUserInfo = PFUser.query()!
        findUserInfo.whereKey("username", equalTo: username)
        
        findUserInfo.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    if object.objectForKey("FullName") != nil {
                        self.fullName.text = object.objectForKey("FullName") as? String
                    } else {
                        self.fullName.text = object.objectForKey("username") as? String
                    }
                    
                    if object.objectForKey("Bio") as? String != nil {
                        self.Bio.text = object.objectForKey("Bio") as? String
                    } else {
                        self.Bio.text = "This user does not have a bio"
                    }
                    
                    if object.objectForKey("ProfilePic") != nil {
                        let downloadedImage: UIImage = UIImage(data: object.objectForKey("ProfilePic")!.getData()!)!
                        self.userProPic.image = downloadedImage as UIImage
                        self.userProPic.contentMode = UIViewContentMode.ScaleAspectFill
                        self.userProPic.clipsToBounds = true
                    } else {
                        self.userProPic.image = UIImage(named: "HarbrLaunchfinal.jpg")
                        self.userProPic.contentMode = UIViewContentMode.ScaleAspectFill
                        self.userProPic.clipsToBounds = true
                    }
                }
            }
        })
    }
    
    @IBAction func follow(sender: UIButton) {
        if isFollowing == false {
            followButton.backgroundColor = UIColorFromRGB("238923", alpha: 1)
            followButton.setTitle("Following", forState: .Normal)
            PFUser.currentUser()!.objectForKey("Following")!.addObject(username)
            PFUser.currentUser()?.saveInBackground()
            
            var followQuery = PFQuery(className: "followersClass")
            followQuery.whereKey("username", equalTo: username)
            followQuery.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    for object in objects! {
                        var userObject: PFObject! = object as! PFObject
                        
                        if object.objectForKey("Followers") != nil {
                            println(object.objectForKey("Followers")!)
                            println(userObject)
                            userObject.addObject(PFUser.currentUser()!.username!, forKey: "followers")
                            userObject.saveInBackgroundWithBlock({
                                (success, error) in
                                
                                if error == nil {
                                    println("The follower worked")
                                } else {
                                    println("There was an error with follower")
                                }
                            })
                        } else {
                            println("worked")
                            userObject["followers"] = [PFUser.currentUser()!.username!]
                            userObject.saveInBackground()
                        }
                        
                        if object.objectForKey("myFollowerInfo") != nil {
                            userObject.addObject("\(PFUser.currentUser()!.username!) has followed you", forKey: "followerInfo")
                            userObject.saveInBackground()
                        } else {
                            userObject.setObject(["\(PFUser.currentUser()!.username!) has followed you"], forKey: "followerInfo")
                        userObject.saveInBackground()
                        }
                        
                        if object.objectForKey("followerTimes") != nil {
                            userObject.objectForKey("followerTimes")!.addObject(self.currentDate)
                            userObject.saveInBackground()
                            
                        } else {
                            userObject.setObject([self.currentDate], forKey: "followerTimes")
                            userObject.saveInBackground()
                            
                        }
                    }
                }
            })
        } else {
            displayAlert("Error", message: "You are already following this user")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = false
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "twitterSegue" {
            var svc = segue.destinationViewController as! TwitterViewController
            svc.username = username
        }
        
        if segue.identifier == "facebookSegue" {
            var svc = segue.destinationViewController as! FacebookViewController
            svc.username = username
            
        }
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

}
