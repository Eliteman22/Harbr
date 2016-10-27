//
//  FeedbackSubmissionViewController.swift
//  
//
//  Created by Flavio Lici on 7/8/15.
//
//

import UIKit
import Parse
import MessageUI
import Foundation

class FeedbackSubmissionViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var feedbackToPost: UITextView!
    
    @IBOutlet var sendButtonAppearance: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        sendButtonAppearance.layer.cornerRadius = 10
        sendButtonAppearance.clipsToBounds = true
        

        username.text = PFUser.currentUser()!.username!
        feedbackToPost.layer.borderWidth = 1
        feedbackToPost.layer.borderColor = UIColor.blackColor().CGColor
        feedbackToPost.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendEmail(sender: UIButton) {
        if feedbackToPost.text.isEmpty {
            alert("Alert", message: "Please enter a message to send to us")
        } else {
            var picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setSubject("Feedback")
            picker.setToRecipients(["media@harbrapp.com"])
            picker.setMessageBody("\(feedbackToPost.text)\n\nFrom: \(PFUser.currentUser()!.username!)", isHTML: true)
            
            presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        feedbackToPost.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    


}
