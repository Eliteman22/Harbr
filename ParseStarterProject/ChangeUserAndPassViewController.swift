//
//  ChangeUserAndPassViewController.swift
//  
//
//  Created by Flavio Lici on 7/2/15.
//
//

import UIKit
import Parse

class ChangeUserAndPassViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentUser: UILabel!
    
    @IBOutlet weak var currentPass: UILabel!

    @IBOutlet weak var nweUser: UITextField!
    
    @IBOutlet weak var newPass: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPass.delegate = self
        self.newPass.delegate = self
        currentUser.text = PFUser.currentUser()!.username
        currentPass.text = PFUser.currentUser()!.password
        
        self.tabBarController?.tabBar.hidden = true
        


    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func update(sender: UIButton) {
        if !nweUser.text.isEmpty && !newPass.text.isEmpty {
            
            
            var followersQuery = PFQuery(className: "followersClass")
            followersQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
            followersQuery.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.setObject(self.nweUser.text, forKey: "username")
                        object.saveInBackground()
                    }
                }
                
            })
            
            
            PFUser.currentUser()!.username! = nweUser.text
            PFUser.currentUser()!.password! = newPass.text
            PFUser.currentUser()!.save()
            alert("Congrats", message: "Your username and pass were changed")
        }
        else if !nweUser.text.isEmpty && newPass.text.isEmpty {
            
            var followersQuery = PFQuery(className: "followersClass")
            followersQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
            followersQuery.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.setObject(self.nweUser.text, forKey: "username")
                        object.saveInBackground()
                    }
                }
                
            })
            
            
            PFUser.currentUser()!.username! = nweUser.text
            PFUser.currentUser()!.save()
            alert("Congrats", message: "Username was changed succesfully")
        }
        else if !newPass.text.isEmpty && nweUser.text.isEmpty {
            PFUser.currentUser()!.password! = newPass.text
            PFUser.currentUser()!.save()
            alert("Congrats", message: "Password was changed succesfully")
        } else {
            alert("Error", message: "Please fill in a field")
        }
    }
    
    func alert(tite: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }


}
