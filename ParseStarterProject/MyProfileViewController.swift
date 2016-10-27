//
//  MyProfileViewController.swift
//  
//
//  Created by Flavio Lici on 7/1/15.
//
//

import UIKit
import Parse

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isPosted: Bool!
    
    var activityIndication = UIActivityIndicatorView()

    @IBOutlet var bioTextView: UITextView!

    @IBOutlet var ProfilePic: UIButton!
    
    @IBOutlet var myTable: UITableView!
    
    @IBOutlet var followers: UILabel!
    
    @IBOutlet var following: UILabel!
    
    @IBOutlet var userPoints: UILabel!
    
    var userPointsText: Int!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier2", forIndexPath: indexPath) as! UITableViewCell
       
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePic.userInteractionEnabled = false
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentDate = dateFormatter.stringFromDate(NSDate())
        
        if checkIfDay(currentDate) == false {
            backgroundImage.image = UIImage(named: "nighttimebackground.png")
        }
        
        PFUser.currentUser()?.fetchInBackground()
        
        
       loadProfile()
        
        self.navigationController?.navigationBar.topItem?.title = PFUser.currentUser()?.username
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
    
    
    
    override func viewDidAppear(animated: Bool) {
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        
        PFUser.currentUser()!.fetchInBackground()
        loadProfile()
            }
    
    func loadProfile () {
        if PFUser.currentUser()?.objectForKey("Points") == nil {
            userPoints.text = "0"
        } else {
            userPointsText = PFUser.currentUser()!.objectForKey("Points") as? Int
            println(userPointsText)
            
            userPoints.text = "\(userPointsText)"
        }
        
        var followersQuery = PFQuery(className: "followersClass")
        followersQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        followersQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    
                    if object.objectForKey("followers") != nil {
                        var followersList = object.objectForKey("followers") as! [String]
                        var followersCount = followersList.count
                        
                        self.followers.text = "\(followersCount)"
                    } else {
                        self.followers.text = "0"
                    }
                    
                }
                
                
            }
            
        })
        
        if PFUser.currentUser()?.objectForKey("Following") == nil {
            following.text = "0"
        } else {
            
            print("it worked")
            let followingArray = PFUser.currentUser()?.objectForKey("Following") as! [String]
            let count = followingArray.count
            following.text = "\(count)"
        }
        
        isPosted = false
        ProfilePic.layer.cornerRadius = ProfilePic.frame.height/2
        ProfilePic.clipsToBounds = true
        ProfilePic.contentMode = UIViewContentMode.ScaleAspectFill
        
        if PFUser.currentUser()!.objectForKey("Bio") == nil {
            bioTextView.text = "You do not have a bio"
        } else {
            bioTextView.text = PFUser.currentUser()!.objectForKey("Bio") as? String
        }
        
        
        if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
            let downloadedImage: UIImage = UIImage(data: PFUser.currentUser()!.objectForKey("ProfilePic")!.getData()!)!
            ProfilePic.setImage(downloadedImage as UIImage, forState: .Normal)
            ProfilePic.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            ProfilePic.imageView?.image = UIImage(named: "placeholder.jpg")
        }

    }

    


  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ProfilePic.setImage(image, forState: .Normal)
        
        isPosted = true

    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    

    
    

}
