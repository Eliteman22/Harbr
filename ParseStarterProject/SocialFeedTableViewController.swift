//
//  SocialFeedTableViewController.swift
//  
//
//  Created by Flavio Lici on 7/1/15.
//
//

import UIKit
import Parse
import Social

class SocialFeedTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet var searchForFriend: UITextField!
    
    
    var refresher: UIRefreshControl!
    
    var timelineDate: NSMutableArray! = NSMutableArray()
    
    var username: String! = ""
    
    var friendToFind: String!
    
    var imageToSend: UIImage! = UIImage()
    
    var objectIdToPass: String!
    
    var imageToPass: UIImage!
    
    var usernameToSend: String!
    
    @IBOutlet var searchView: UIView!
    
    @IBOutlet var widthOfTopBar: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        widthOfTopBar.constant = self.view.frame.width / 2
        
        self.navigationItem.title = "Social Feed"
        
        self.navigationController?.navigationBarHidden = false
        
        UIApplication.sharedApplication().statusBarHidden = false
        

        UITabBar.appearance().backgroundImage = UIImage(named: "DATNEWNEWBOTTOM.png")
        
        searchForFriend.delegate = self
    
        
        refresher = UIRefreshControl()

        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewDidAppear(animated: Bool) {
       
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return timelineDate.count
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("socialFeedIdentifier", forIndexPath: indexPath) as! SocialCellTableViewCell
        
        if timelineDate.count > 0 && timelineDate.count >= indexPath.row {
        
        
        let post: PFObject = self.timelineDate.objectAtIndex(indexPath.row) as! PFObject
        
        cell.userInteractionEnabled = false
        
        cell.eventName.alpha = 0
        cell.imageToPost.alpha = 0
        cell.comment.alpha = 0
        cell.username.alpha = 0
        cell.dateCreated.alpha = 0
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        cell.imageToPost.clipsToBounds = true
        cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        var nameOfEvent = (post.objectForKey("eventName") as? String)
        cell.comment.text = post.objectForKey("comment") as? String
        
        
        if Array(arrayLiteral: nameOfEvent)[0] == "#" {
            cell.eventName.text = "\(nameOfEvent)"
        } else {
            cell.eventName.text = "#\(nameOfEvent!)"
        }
        cell.username.setTitle(post.objectForKey("username") as? String, forState: .Normal)
        cell.dateCreated.text = post.objectForKey("timePosted") as? String
        cell.objectIdOfImage.text = post.objectId
        
        if UIImage(data: (post.objectForKey("imageFile")?.getData()!)!) != nil {
            post.objectForKey("imageFile")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                
                    let downloadedImage = UIImage(data: data!)
                    cell.imageToPost.image = downloadedImage
                    cell.imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
                }
                
                
            })
        } else {
            cell.imageToPost.image = UIImage(named: "placeholder.jpg")
        }
        
        if post.objectForKey("userImage") != nil {
            
            post.objectForKey("userImage")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    cell.userImage.image = downloadedImage
                }
            })
            
        } else {
            cell.userImage.image = UIImage(named: "placeholder.jpg")
        }
        
        UIView.animateWithDuration(0, animations: {
            cell.eventName.alpha = 1
            cell.imageToPost.alpha = 1
            cell.comment.alpha = 1
            cell.username.alpha = 1
            cell.dateCreated.alpha = 1
        })

        }
        return cell
    }
    
    @IBAction func loadData() {
        timelineDate.removeAllObjects()
        
        var findTimeLineData: PFQuery = PFQuery(className: "SocialFeed")
        findTimeLineData.addDescendingOrder("createdAt")
        
        findTimeLineData.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineDate.addObject(object)
                }
                
//                let array: NSArray = self.timelineDate.reverseObjectEnumerator().allObjects
//                self.timelineDate = array.mutableCopy() as? NSMutableArray
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func refresh() {
        loadData()
        self.refresher.endRefreshing()
    }
    
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        
//        let post: PFObject = self.timelineDate.objectAtIndex(indexPath.row) as! PFObject
//        usernameToSend = post.objectForKey("username") as? String
//        
//        if UIImage(data: (post.objectForKey("imageFile")?.getData()!)!) != nil {
//            post.objectForKey("imageFile")!.getDataInBackgroundWithBlock({
//                (data: NSData?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    
//                    let downloadedImage = UIImage(data: data!)
//                    self.imageToSend = downloadedImage
//                }
//                
//                
//            })
//        } else {
//            imageToSend = UIImage(named: "placeholder.jpg")
//        }
//        
//        objectIdToPass = post.objectId
//        
//        return indexPath
//        
//    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let post: PFObject = self.timelineDate.objectAtIndex(indexPath.row) as! PFObject
        usernameToSend = post.objectForKey("username") as? String
        
        if UIImage(data: (post.objectForKey("imageFile")?.getData()!)!) != nil {
            post.objectForKey("imageFile")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    let downloadedImage = UIImage(data: data!)
                    
                }
                
                
            })
        } else {
            imageToSend = UIImage(named: "placeholder.jpg")
        }
        
        objectIdToPass = post.objectId
        
        return indexPath
        
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
       
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let post: PFObject = self.timelineDate.objectAtIndex(indexPath.row) as! PFObject
        usernameToSend = post.objectForKey("username") as? String
        
        if UIImage(data: (post.objectForKey("imageFile")?.getData()!)!) != nil {
            post.objectForKey("imageFile")!.getDataInBackgroundWithBlock({
                (data: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    let downloadedImage = UIImage(data: data!)
                    self.imageToSend = downloadedImage
                }
                
                
            })
        } else {
            imageToSend = UIImage(named: "placeholder.jpg")
        }
        
        objectIdToPass = post.objectId
        
        self.performSegueWithIdentifier("displayUserSegue", sender: self)
        
//        self.performSegueWithIdentifier("displayUserSegue", sender: self)
//        println("it was highlighted yo")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
                self.navigationItem.setHidesBackButton(true, animated: false)
        loadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayUserSegue" {
            var svc = segue.destinationViewController as! EnlargeSocialFeedPostViewController
            svc.username = usernameToSend
            svc.socialFeedImage = imageToSend
            svc.objectIdOfImage = objectIdToPass
        }
        
        if segue.identifier == "findFriendsSegue" {
            var svc = segue.destinationViewController as! searchForFriendTableViewController
            svc.userNameSearched = friendToFind
        }
        
        if segue.identifier == "postToSocialFeedSegue" {
            
            var svc = segue.destinationViewController as! SocialUploadViewController
            svc.imageHasBeenSent = imageToPass
            
        }
    }
    
    @IBAction func findFriend(sender: UIButton) {
        if searchForFriend.text != nil {
            friendToFind = searchForFriend.text
        performSegueWithIdentifier("findFriendsSegue", sender: self)
        } else {
            alert("Alert", message: "Please enter a username to search")
        }
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPass = image
        
        performSegueWithIdentifier("postToSocialFeedSegue", sender: self)

    }
    
    @IBAction func postAnImage(sender: UIBarButtonItem) {
        var image = UIImagePickerController()
        image.delegate = self
        
            
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchView.endEditing(true)
        self.view.endEditing(true)
        searchForFriend.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        searchView.endEditing(true)
        self.view.endEditing(true)
        searchForFriend.resignFirstResponder()
    }
    
    func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        
        let maskRef = maskImage.CGImage
        
        let mask = CGImageMaskCreate(
            CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef),
            nil,
            false)
        
        let masked = CGImageCreateWithMask(image.CGImage, mask)
        let maskedImage = UIImage(CGImage: masked)!
        
        // No need to release. Core Foundation objects are automatically memory managed.
        
        return maskedImage
        
    }
    
    @IBAction func clearBox(sender: UIButton) {
        searchForFriend.text = ""
        searchForFriend.resignFirstResponder()
    }


}
