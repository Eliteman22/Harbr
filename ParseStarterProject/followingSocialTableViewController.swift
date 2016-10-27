//
//  followingSocialTableViewController.swift
//  
//
//  Created by Flavio Lici on 8/2/15.
//
//

import UIKit
import Parse

class followingSocialTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIDocumentInteractionControllerDelegate  {
    
    var imageToPass: UIImage!
    
    var infoArray: NSMutableArray! = NSMutableArray()
    
    var usernamesArray: [String] = []
    
    var usernameToPass: String!
    
    var userTimesArray: NSMutableArray! = NSMutableArray()
    
    var timeUserFollowed: String!
    
    @IBOutlet var widthOfFollowers: NSLayoutConstraint!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        PFUser.currentUser()?.fetchInBackground()
        
        widthOfFollowers.constant = self.view.frame.width / 2
        
        var followersQuery = PFQuery(className: "followersClass")
        followersQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        followersQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
            
            for object in objects! {
                println(object)
                if object.objectForKey("followerInfo") != nil {
                    var followerInfoArray = object.objectForKey("followerInfo") as! NSMutableArray
                    self.infoArray = followerInfoArray as NSMutableArray
                    

                } else {
                    self.alert("Alert", message: "No one has followed you")
                }
                if object.objectForKey("followerTimes") != nil {
                    var followerTimesArray = object.objectForKey("followerTimes") as! NSMutableArray
                    self.userTimesArray = followerTimesArray as NSMutableArray
                    
                    
                  
                } else {
                    self.alert("Alert", message: "No one has followed you")
                }
                
            }
                
                let array1: NSArray = self.infoArray.reverseObjectEnumerator().allObjects
                self.infoArray = array1.mutableCopy() as? NSMutableArray
                
                let array2: NSArray = self.userTimesArray.reverseObjectEnumerator().allObjects
                self.userTimesArray = array2.mutableCopy() as? NSMutableArray
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            
            }
        
        })

        
        

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
        
        if infoArray != nil {
        
            return infoArray.count
        } else {
            alert("Alert", message: "No one has followed you")
            return 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        PFUser.currentUser()!.fetchInBackground()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myFollowerInfo", forIndexPath: indexPath) as! FollowingCellSocialTableViewCell
        
        cell.imageToPost.alpha = 0
        cell.followingNews.alpha = 0
        


        if infoArray.count > 0 && infoArray.count >= indexPath.row{
            
            println("\(infoArray.count)")
            println(userTimesArray)
            
            cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
            cell.imageToPost.clipsToBounds = true
            
            var userFollowingYou1 = infoArray.objectAtIndex(indexPath.row) as? String
            
            var usernameToSearch1: [String] = userFollowingYou1!.componentsSeparatedByString(" ")
            
            println("it worked1")
            
            var followingNewsString: NSString = (infoArray.objectAtIndex(indexPath.row) as? NSString)!
            var myMutableString = NSMutableAttributedString(string: followingNewsString as String)
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB("3f76a5", alpha: 1.0), range: NSRange(location: 0, length: count(usernameToSearch1[0])))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 16.0)!, range: NSRange(location: 0, length: count(usernameToSearch1[0])))
            
            cell.followingNews.attributedText = myMutableString
         
            
            println("it worked2")
            var userFollowingYou = infoArray.objectAtIndex(indexPath.row) as? String
            
            println("it worked3")
            
            if userTimesArray.objectAtIndex(indexPath.row) as? String != nil{
                println("made into loop")
                timeUserFollowed = userTimesArray.objectAtIndex(indexPath.row) as? String
                
                cell.timePosted.text = timeUserFollowed
            }
            
            println("Should be working")
            
            
            
            
            var usernameToSearch: [String] = userFollowingYou!.componentsSeparatedByString(" ")
            var usernameToQuery = usernameToSearch[0]
            usernamesArray.append(usernameToQuery)
            
            println(usernameToQuery)

            
            var queryUsers = PFUser.query()
            queryUsers?.whereKey("username", equalTo: usernameToQuery)
            
            queryUsers?.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                println("Grabbed objects jerome")
                
                if error == nil {
                    for object in objects! {
                        if object.objectForKey("ProfilePic") != nil {
                            object.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock( {
                                
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
            
        } else {
            alert("Alert", message: "You have no follower info")
        }
        
        UIView.animateWithDuration(0.3, animations: {
            cell.imageToPost.alpha = 1
            cell.followingNews.alpha = 1
        })

        return cell
    }
    
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        usernameToPass = usernamesArray[indexPath.row]
        
        return indexPath
    }

    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewFollowHIstory" {
            var svc = segue.destinationViewController as! RsvpDisplayProfileViewController
            svc.username = usernameToPass
            
        }
    }


}
