//
//  SignUpViewController.swift
//  
//
//  Created by Flavio Lici on 6/29/15.
//
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var doesExist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self
        self.username.delegate = self
        self.password.delegate = self
        email.layer.borderWidth = 1
        username.layer.borderWidth = 1
        password.layer.borderWidth = 1
        email.layer.borderColor = UIColorFromRGB("ED9F50", alpha: 1.0).CGColor
        username.layer.borderColor = UIColorFromRGB("ED9F50", alpha: 1.0).CGColor
        password.layer.borderColor = UIColorFromRGB("ED9F50", alpha: 1.0).CGColor

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func signUp(sender: UIButton) {
        var user = PFUser()
        
        if email.text != nil && username.text != nil && password.text != nil {
            
            user.username = username.text
            user.password = password.text
            user.email = email.text
            
            user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if error != nil {
                    
                    let errorString = error!.userInfo?["error"] as? NSString
                    self.alert("Error", message: errorString as! String)
                    
                } else {
                    
                    self.performSegueWithIdentifier("signupToTerms", sender: self)
                }
                
            }
            
        }
        
        else {
            alert("Error", message: "Please fill in all fields")
        }
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signUpWithFacebook(sender: UIButton) {
        
        let permissions = ["public_profile"]
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name"])
                    
                    // Send request to Facebook
                    request.startWithCompletionHandler {
                        
                        (connection, result, error) in
                        
                        if error != nil {
                            self.alert("Error", message: "There was an error getting your facebook infomration")
                        }
                        else if let userData = result as? [String:AnyObject] {
                            
                            println(userData)
                            
                            let installation = PFInstallation.currentInstallation()
                            let acl = PFACL(user: PFUser.currentUser()!) // Only user can write
                            acl.setPublicReadAccess(true) // Everybody can read
                            acl.setPublicWriteAccess(true) // Also Admins can write
                            installation.ACL = acl
                            installation.saveInBackground()
                            
                            let username = userData["name"] as? String
                            let email = userData["email"] as? String
                            var usersQuery = PFUser.query()
                            usersQuery?.findObjectsInBackgroundWithBlock({
                                (objects: [AnyObject]?, error: NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        if object.objectForKey("username") as! String == username! {
                                            self.doesExist = true
                                        }
                                    }
                                    
                                    if self.doesExist == true {
                                        PFUser.currentUser()?.username = "\(username)17"
                                        PFUser.currentUser()?.email = email
                                        PFUser.currentUser()?.saveInBackgroundWithBlock({
                                            (success, error) in
                                            if error != nil {
                                                println("ERROR IT DID NOT FUCKING WORK")
                                            }
                                        })
                                    } else {
                                        PFUser.currentUser()?.username = username
                                        PFUser.currentUser()?.email = email
                                        PFUser.currentUser()?.saveInBackgroundWithBlock({
                                            (success, error) in
                                            if error != nil {
                                                println("ERROR IT DID NOT FUCKING WORK")
                                            }
                                        })
                                    }
                                }
                                
                            })
                            
                            // Access user data
                            
                            println(username)
                            
                            
                            
                            
                            
                            let userId = result["id"] as! String
                            
                            let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                            
                            if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                                
                                if let data = NSData(contentsOfURL: fbpicUrl) {
                                    
                                    
                                    let imageFile:PFFile = PFFile(data: data)
                                    
                                    PFUser.currentUser()?["ProfilePic"] = imageFile
                                    
                                    PFUser.currentUser()?.save()
                                    
                                }
                                
                            }
                            
                            
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
                            
                            
                            let aclNew = PFACL()
                            aclNew.setPublicReadAccess(true)
                            aclNew.setPublicWriteAccess(true)
                            userObject.ACL = aclNew
                            
                            
                            userObject["username"] = username
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
                                        self.alert("Error", message: "There was an error getting your followers")
                                    }
                                })
                                
                            }
                            
                            
                            
                            self.performSegueWithIdentifier("signupWithFacebook", sender: self)
                        }
                    }
                } else {
                    println("User logged in through Facebook!")
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name"])
                    
                    // Send request to Facebook
                    request.startWithCompletionHandler {
                        
                        (connection, result, error) in
                        
                        if error != nil {
                            self.alert("Error", message: "There was an error getting your facebook infomration")
                        }
                        else if let userData = result as? [String:AnyObject] {
                            
                            println(userData)
                            
                            // Access user data
                            let username = userData["name"] as? String
                            let email = userData["email"] as? String
                            println(username)
                            PFUser.currentUser()?.username = username
                            PFUser.currentUser()?.email = email
                            PFUser.currentUser()?.saveInBackground()
                            
                            let userId = result["id"] as! String
                            
                            let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                            
                            if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                                
                                if let data = NSData(contentsOfURL: fbpicUrl) {
                                    
                                    
                                    let imageFile:PFFile = PFFile(data: data)
                                    
                                    PFUser.currentUser()?["ProfilePic"] = imageFile
                                    
                                    PFUser.currentUser()?.save()
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            self.performSegueWithIdentifier("loggedIn", sender: self)
                        }
                    }
                    
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
            
            
        }

        
        
        
    }

        

}
