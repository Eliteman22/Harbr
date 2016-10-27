//
//  ComplaintViewController.swift
//  
//
//  Created by Flavio Lici on 9/8/15.
//
//

import UIKit
import Foundation
import MessageUI

class ComplaintViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var nameOfPersonToReport: UITextField!
    
    @IBOutlet var reasonForComplaint: UITextField!
    
    @IBOutlet var submissionNotice: UITextView!
    
    @IBOutlet var finishButtonAlpha: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        submissionNotice.alpha = 0
        finishButtonAlpha.alpha = 0
        finishButtonAlpha.userInteractionEnabled = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendComplaint(sender: UIButton) {
        if !nameOfPersonToReport.text.isEmpty && !reasonForComplaint.text.isEmpty {
            var picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setSubject("Complaint")
            picker.setToRecipients(["media@harbrapp.com"])
            picker.setMessageBody("I would like to report: \(nameOfPersonToReport.text)                Reason for Complaint: \(reasonForComplaint.text)", isHTML: true)
            
            presentViewController(picker, animated: true, completion: nil)
        } else {
            alert("Error", message: "Please fill in all fields")
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        nameOfPersonToReport.resignFirstResponder()
        reasonForComplaint.resignFirstResponder()
        
        UIView.animateWithDuration(1.0, animations: {
            self.submissionNotice.alpha = 1
            self.finishButtonAlpha.alpha = 1
            self.finishButtonAlpha.userInteractionEnabled = true
        })
        
        
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }



}
