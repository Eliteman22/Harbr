//
//  EditBioViewController.swift
//  
//
//  Created by Flavio Lici on 7/2/15.
//
//

import UIKit
import Parse

class EditBioViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet var updateButton: UIButton!
    
    
    @IBOutlet weak var bio: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullName.delegate = self
        self.bio.delegate = self
        bio.layer.borderWidth = 1
        bio.layer.borderColor = UIColorFromRGB("ffaa57", alpha: 0.8).CGColor
        
        fullName.layer.borderWidth = 1
        fullName.layer.borderColor = UIColorFromRGB("ffaa57", alpha: 0.8).CGColor
        updateButton.layer.cornerRadius = 10
        updateButton.clipsToBounds = true

        
        if PFUser.currentUser()!.objectForKey("FullName") != nil {
            fullName.text =  PFUser.currentUser()!.objectForKey("FullName") as! String
        } else {
            fullName.text = ""
        }
        
        if PFUser.currentUser()!.objectForKey("Bio") != nil {
            bio.text = PFUser.currentUser()!.objectForKey("Bio") as! String
        } else {
            bio.text = ""
        }

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

    @IBAction func update(sender: UIButton) {
        if bio.text != nil && fullName.text != nil {
            PFUser.currentUser()!.setObject(fullName.text, forKey: "FullName")
            PFUser.currentUser()!.setObject(bio.text, forKey: "Bio")
            PFUser.currentUser()?.saveInBackground()
            alert("Congratulations", message: "You have updated your information")
        } else {
            alert("Error", message: "Make sure to fill in all fields")
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
