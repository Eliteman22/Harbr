//
//  CommentsViewController.swift
//  
//
//  Created by Flavio Lici on 7/13/15.
//
//

import UIKit
import Parse

class CommentsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var commentFIeld: UITextField!

    @IBOutlet var myTable: UITableView!
    
    var objectId: String!
    
    var eventName: String!
    
    var eventOwner: String!
    
    var refresher: UIRefreshControl!
    
    @IBOutlet var raiseKeyboard: NSLayoutConstraint!
    
    
    var timelineData: NSMutableArray! = NSMutableArray()
    
    @IBOutlet var myProfilePicture: UIImageView!
    
    @IBOutlet var imageInFeed: UIImageView!
    
    @IBOutlet var submitButtonAlpha: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""

        myTable.delegate = self
        myTable.dataSource = self
        commentFIeld.delegate = self
        myProfilePicture.contentMode = UIViewContentMode.ScaleAspectFill
        myProfilePicture.clipsToBounds = true
        myProfilePicture.layer.cornerRadius = myProfilePicture.frame.height/2
        
        submitButtonAlpha.alpha = 0
        submitButtonAlpha.userInteractionEnabled = false
        
        if PFUser.currentUser()!.username! == eventOwner {
            self.myProfilePicture.image = UIImage(named: "REDwizard.png")
        } else {
            if PFUser.currentUser()!.objectForKey("ProfilePic") != nil {
                
                PFUser.currentUser()!.objectForKey("ProfilePic")!.getDataInBackgroundWithBlock({
                    (data: NSData?, error: NSError?) -> Void in
                    
                    if error == nil {
                        let downloadedImage = UIImage(data: data!)
                        self.myProfilePicture.image = downloadedImage
                    }
                })
                
            } else {
                self.myProfilePicture.image = UIImage(named: "placeholder.jpg")
            }
        }
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh comments")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        
        

        
        
        self.myTable.addSubview(refresher)
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendComment(sender: UIButton) {
        
        if commentFIeld.text.isEmpty {
            alert("Error", message: "Please enter a comment")
        } else {
            var comment: PFObject = PFObject(className: "\(objectId)comments")
            comment["comment"] = self.commentFIeld.text
            if PFUser.currentUser()!.username! == eventOwner {
                comment["isOwner"] = true
            } else {
                comment["isOwner"] = false
            }
            
            comment["usernamePosted"] = PFUser.currentUser()!.username!
            
            let imageData: UIImage = myProfilePicture.image!
            
            let imageFile = PFFile(name: "ProPic.png", data: UIImageJPEGRepresentation(imageData, 0.5))
            
            comment["userImage"] = imageFile
            comment.saveInBackground()
            
            commentFIeld.text = ""
            
            self.refresh()
            
        }
        myTable.reloadData()
        
        
    }
    
    func refresh() {
        loadData()
        refresher.endRefreshing()
    }
    
    @IBAction func loadData() {
        timelineData.removeAllObjects()
        
        var findTimelineData: PFQuery = PFQuery(className: "\(objectId)comments")
        
        findTimelineData.findObjectsInBackgroundWithBlock( {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                    
                }
                
                let array: NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = array.mutableCopy() as? NSMutableArray
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.myTable.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
              let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CommentCellTableViewCell
        
        if timelineData.count >= indexPath.row {
        
  
        let event: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.CommentBlock.alpha = 0
        cell.dateCreated.alpha = 0
        
        if event.objectForKey("isOwner") as! Bool == true {
            println("It worked")
            
            cell.CommentBlock.textColor = UIColorFromRGB("ffaa57", alpha: 1.0)
        } else {
            println("didn't work")
            }
            if event.objectForKey("usernamePosted") != nil {
                
                cell.usernamePosted.text = event.objectForKey("usernamePosted") as? String
            }
            
            if (event.objectForKey("userImage")) != nil {
                
                event.objectForKey("userImage")!.getDataInBackgroundWithBlock({
                    
                    (data: NSData?, error: NSError?) -> Void in
                    
                    if error == nil {
                        let downloadedImage = UIImage(data: data!)
                        cell.imageInFeed.image = downloadedImage
                        cell.imageInFeed.layer.cornerRadius = cell.imageInFeed.frame.height/2
                        
                        if PFUser.currentUser()!.username! == event.objectForKey("usernamePosted") as? String {
                            cell.backgroundColor = self.UIColorFromRGB("a4d6e9", alpha: 0.7)
                    }
                        cell.imageInFeed.clipsToBounds = true
                    } else {
                        self.alert("Error", message: "There was an error downloading your feed")
                    }
                    
                })
                
                
                
            }
        

        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd:mm"
        cell.dateCreated.text = dateFormatter.stringFromDate(event.createdAt!)
        
        cell.CommentBlock.text = event.objectForKey("comment") as? String
        
        UIView.animateWithDuration(0.2, animations: {
            cell.CommentBlock.alpha = 1
            cell.dateCreated.alpha = 1
        })
        }
        
        return cell
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, animations: {
            self.raiseKeyboard.constant = 0
        })
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
        commentFIeld.resignFirstResponder()
        UIView.animateWithDuration(0.5, animations: {
            self.raiseKeyboard.constant = 0
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(1.0, animations: {
            self.submitButtonAlpha.alpha = 1
            self.submitButtonAlpha.userInteractionEnabled = true
            self.raiseKeyboard.constant = self.view.frame.height / 2.75
        })
    }


}
