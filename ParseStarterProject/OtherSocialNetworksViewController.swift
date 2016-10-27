//
//  OtherSocialNetworksViewController.swift
//  
//
//  Created by Flavio Lici on 8/1/15.
//
//

import UIKit
import Parse

class OtherSocialNetworksViewController: UIViewController {
    
    @IBOutlet var twitterName: UITextField!
    
    @IBOutlet var facebookName: UITextField!
    
    var initialTwitter: String!
    var initialFB: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser()!.objectForKey("twitterName") != nil {
            twitterName.text = PFUser.currentUser()!.objectForKey("twitterName") as! String
          
            
        }
        
        self.tabBarController?.tabBar.hidden = true

        
        if PFUser.currentUser()!.objectForKey("facebookName") != nil {
            facebookName.text = PFUser.currentUser()!.objectForKey("facebookName") as! String
        }
        
        initialTwitter = twitterName.text
        initialFB = facebookName.text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func update(sender: UIButton) {
        
        if !twitterName.text.isEmpty && !facebookName.text.isEmpty {
            
            PFUser.currentUser()!.setObject(twitterName.text, forKey: "twitterName")
            PFUser.currentUser()?.saveInBackground()
            displayAlert("Congrats", message: "Your facebook and twitter name was updated")
        }
        
        else if !twitterName.text.isEmpty {
            PFUser.currentUser()!.setObject(twitterName.text, forKey: "twitterName")
            PFUser.currentUser()?.saveInBackground()
            displayAlert("Congrats", message: "Twitter name updated")
        } else if !facebookName.text.isEmpty {
            PFUser.currentUser()!.setObject(facebookName.text, forKey: "facebookName")
            displayAlert("Congrats", message: "New facebook name posted")
            PFUser.currentUser()?.saveInBackground()
        } else {
            displayAlert("Error", message: "Cannot Display")
        }
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
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
