//
//  GroupChatViewController.swift
//  
//
//  Created by Flavio Lici on 7/3/15.
//
//

import UIKit
import Parse

class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var objectId: String!
    var objectName: String!
    
    @IBOutlet var tableView: UITableView!
    
    var timelineData: NSMutableArray! = NSMutableArray()

    @IBOutlet var commentPost: UITextField!
    
    @IBOutlet var textViewHeight: NSLayoutConstraint!
    
    
    var refresher: UIRefreshControl!
    
    var timer: NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(objectId)
        
        tableView.userInteractionEnabled = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.commentPost.delegate = self
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh messages")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
       
        
        loadData()
        

        
    }
    
    func refresh() {
        loadData()
        self.refresher.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    @IBAction func send(sender: UIButton) {
        if commentPost.text.isEmpty {
            alert("Alert", message: "Enter a message before sending!")
        } else {
            var message: PFObject = PFObject(className: "\(objectId)groupChat")
            message["message"] = self.commentPost.text
            
            message.saveInBackground()
            
            commentPost.text = ""
            loadData()
        }
    
    }
    
    @IBAction func loadData() {
        timelineData.removeAllObjects()
        
        var findTimelineData: PFQuery = PFQuery(className: "\(objectId)groupChat")
        
        findTimelineData.findObjectsInBackgroundWithBlock( {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    self.timelineData.addObject(object)
                }
                
                let array: NSArray = self.timelineData
                self.timelineData = array.mutableCopy() as? NSMutableArray
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupChatCell", forIndexPath: indexPath) as! GroupChatTableViewCell
        let message: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.commentsBlock.alpha = 0
        cell.dateCreated.alpha = 0
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd:mm"
        cell.dateCreated.text = dateFormatter.stringFromDate(message.createdAt!)
        
        cell.commentsBlock.text = message.objectForKey("message") as? String
        
        UIView.animateWithDuration(0.2, animations: {
            cell.commentsBlock.alpha = 1
            cell.dateCreated.alpha = 1
        })
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatToUserList" {
            var svc = segue.destinationViewController as! RsvpListTableViewController
            svc.objectId = objectId
            svc.objectName = objectName
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        commentPost.resignFirstResponder()
        UIView.animateWithDuration(0.5, animations: {
            self.textViewHeight.constant = 42
        })
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.commentPost.endEditing(true)
        
        commentPost.resignFirstResponder()
        UIView.animateWithDuration(0.5, animations: {
            self.textViewHeight.constant = 42
        })
    }
    
    func alert(tite: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(1.0, animations: {
            self.textViewHeight.constant = self.view.frame.height / 2.35
        })
    }
    
    

}
