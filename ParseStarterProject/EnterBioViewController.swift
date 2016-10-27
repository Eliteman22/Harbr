//
//  EnterBioViewController.swift
//  
//
//  Created by Flavio Lici on 8/22/15.
//
//

import UIKit
import Parse

class EnterBioViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var bioBox: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextScreen(sender: UIButton) {
        if bioBox.text != nil {
            var bio = bioBox.text
            PFUser.currentUser()?.setObject(bio, forKey: "Bio")
            
            
            self.performSegueWithIdentifier("submitBio", sender: self)
        } else {
            displayAlert("Error", message: "Please enter a bio")
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

}
