//
//  uploadEventToSocialsViewController.swift
//  
//
//  Created by Flavio Lici on 8/24/15.
//
//

import UIKit
import Parse
import Social

class uploadEventToSocialsViewController: UIViewController {
    
    var eventName: String!
    
    var eventType: String!
    
    var eventDescription: String!
    
    var eventDate: String!
    
    var eventTime: String!
    
    var eventImage: UIImage!
    
    var eventLocation: String!
    
    var eventVenue: String!
    
    var eventLat: Double!
    
    var eventLon: Double!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitEvent(sender: UIButton) {
        
        if !eventName.isEmpty && !eventType.isEmpty && !eventDescription.isEmpty && !eventDate.isEmpty && !eventTime.isEmpty && eventImage != nil && !eventLocation.isEmpty {
            
            println("working1")
            
            var post: PFObject = PFObject(className: "eventPosts")
            let acl = PFACL()
            acl.setPublicReadAccess(true)
            acl.setPublicWriteAccess(true)
            post.ACL = acl
            
            println("working2")
            
            post["eventOwner"] = PFUser.currentUser()!.username
            post["eventName"] = eventName
            println(eventName)
            post["description"] = eventDescription
            
            post["location"] = eventLocation
            
            if eventLat != nil {
                post["lat"] = eventLat
            }
            
            if eventLon != nil {
                 post["lon"] = eventLon
            }
           
            
            println("working3")
            
            post["eventType"] = eventType
            
            
            if eventVenue != nil {
                post["venueName"] = eventVenue
            }
                
            post["date"] = eventDate
            
            post["rsvpList"] = [PFUser.currentUser()!.username!]
            post["eventTime"] = eventTime
            
            println("working4")
            
            if PFUser.currentUser()?.objectForKey("eventsHosting") != nil {
                PFUser.currentUser()?.addObject(eventName, forKey: "eventsHosting")
            } else {
                PFUser.currentUser()?.setObject([eventName], forKey: "eventsHosting")
            }
            
            println("working5")
            
            
            if eventImage != nil {
                let imageData = eventImage
                let imageFile: PFFile = PFFile(name: "image.png", data: UIImageJPEGRepresentation(imageData, 0.8))
                post["imageFIle"] = imageFile
            } else {
                displayAlert("Error", message: "Image Could not be posted!")
            }
            
            if PFUser.currentUser()!.objectForKey("Points") == nil {
                PFUser.currentUser()!.setObject(10, forKey: "Points")
            } else {
                var currentPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
                var newScore: Int = currentPoints! + 10
                PFUser.currentUser()!.setObject(newScore, forKey: "Points")
            }
            PFUser.currentUser()!.saveInBackground()
            post.saveInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    if PFUser.currentUser()!.objectForKey("eventsAttending") == nil {
                        PFUser.currentUser()!.setObject([post.objectId!], forKey: "eventsAttending")
                    } else {
                        PFUser.currentUser()!.objectForKey("eventsAttending")!.addObject(post.objectId!)
                    }
                    
                    if PFUser.currentUser()!.objectForKey("eventsAttendingName") != nil {
                        PFUser.currentUser()?.addObject(self.eventName, forKey: "eventsAttendingName")
                    } else {
                        PFUser.currentUser()?.setObject([self.eventName], forKey: "eventsAttendingName")
                    }
                    
                    PFUser.currentUser()?.saveInBackground()
                } else {
                    self.displayAlert("Alert", message: "There was an error posting your event")
                }
                
            })
            
            println("working6")
            
            self.performSegueWithIdentifier("eventSubmitted", sender: self)
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "There was an error submitting your event"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
            
    }
    
    @IBAction func shareToFacebook(sender: UIButton) {
        
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

        
        if eventImage != nil {
            shareToFacebook.addImage(eventImage)
        } else {
            displayAlert("Error", message: "Please upload an image")
        }
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func shareToTwitter(sender: UIButton) {
        
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        if eventImage != nil {
            shareToTwitter.addImage(eventImage)
        } else {
            displayAlert("Error", message: "Please upload an image")
        }
        
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
    }
    
        
        
}
    


