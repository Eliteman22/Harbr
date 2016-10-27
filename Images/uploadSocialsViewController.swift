//
//  uploadSocialsViewController.swift
//  
//
//  Created by Flavio Lici on 8/22/15.
//
//

import UIKit
import Parse

class uploadSocialsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var twitterHandle: UITextField!
    
    @IBOutlet var facebookHandle: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        twitterHandle.alpha = 0
        facebookHandle.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func twitterButton(sender: UIButton) {
        UIView.animateWithDuration(0.7, animations: {
            self.twitterHandle.alpha = 1
        })
        
    }
    
    @IBAction func facebookButton(sender: UIButton) {
        
        UIView.animateWithDuration(0.7, animations: {
            self.facebookHandle.alpha = 1
        })
    }
    
    @IBAction func finish(sender: UIButton) {
        if !twitterHandle.text.isEmpty && !facebookHandle.text.isEmpty {
            
            let fbName = facebookHandle.text
            
            let twitName = twitterHandle.text
            
            PFUser.currentUser()?.setObject(fbName, forKey: "facebookName")
            
            PFUser.currentUser()?.setObject(twitName, forKey: "twitterName")
            PFUser.currentUser()?.saveInBackground()
            self.performSegueWithIdentifier("signupToTabBar", sender: self)
        } else if !twitterHandle.text.isEmpty && facebookHandle.text.isEmpty {
            
            let twitName = twitterHandle.text
            
            PFUser.currentUser()?.setObject(twitName, forKey: "twitterName")
            
            PFUser.currentUser()?.saveInBackground()
            
            self.performSegueWithIdentifier("signupToTabBar", sender: self)
            
        } else if !facebookHandle.text.isEmpty && twitterHandle.text.isEmpty {
            
            let fbName = facebookHandle.text
            
            PFUser.currentUser()?.setObject(fbName, forKey: "facebookName")
            
            PFUser.currentUser()?.saveInBackground()
            
            self.performSegueWithIdentifier("signupToTabBar", sender: self)
            
        } else {
            displayAlert("Error", message: "Please fill in one of the fields")
        }
        

    }
    
    
    
   
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        textView.resignFirstResponder()
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupToTabBar"  || segue.identifier == "skipSocials"{
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            
            let currentMonth = dateFormatter.stringFromDate(NSDate())
            
            let dateFormatterTime = NSDateFormatter()
            dateFormatterTime.timeStyle = .ShortStyle
            
            let currentTime = dateFormatterTime.stringFromDate(NSDate())
            
            let currentDate = "\(currentMonth), \(currentTime)"
            
            PFUser.currentUser()?.addObject("flaviolici", forKey: "Following")
            PFUser.currentUser()?.addObject("diego", forKey: "Following")
            PFUser.currentUser()?.addObject("seymurm", forKey: "Following")
            
            PFUser.currentUser()?.saveInBackground()
            var userObject = PFObject(className: "followersClass")
            
            
            let acl = PFACL()
            acl.setPublicReadAccess(true)
            acl.setPublicWriteAccess(true)
            userObject.ACL = acl
            
            
            userObject["username"] = PFUser.currentUser()!.username!
            userObject["followers"] = ["flaviolici", "diego", "seymurm"]
            userObject["followerInfo"] = ["flaviolici has followed you", "diego has followed you", "seymurm has followed you"]
            userObject["followerTimes"] = [currentDate, currentDate, currentDate]
            userObject.saveInBackground()
            
            let adminArray = ["flaviolici", "diego", "seymurm"]
            
            for admin in adminArray {
                
                var adminQuery = PFQuery(className: "followersClass")
                adminQuery.whereKey("username", equalTo: admin)
                adminQuery.findObjectsInBackgroundWithBlock({
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        for object in objects! {
                            object.addObject(PFUser.currentUser()!.username!, forKey: "followers")
                            object.addObject("\(PFUser.currentUser()!.username!) has followed you", forKey: "followerInfo")
                            object.addObject(currentDate, forKey: "followerTimes")
                            object.saveInBackground()
                        }
                        
                       
                    } else {
                        self.displayAlert("Error", message: "There was an error getting your followers")
                    }
                })
            
            }
            
        }
    }
    
    

}
