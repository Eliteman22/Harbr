//
//  NoEventsViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Parse

class NoEventsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var createEvent: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyButton.layer.cornerRadius = 10
        applyButton.clipsToBounds = true
        
        createEvent.layer.cornerRadius = 10
        createEvent.clipsToBounds = true

        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apply(sender: UIButton) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Ambassador Application")
        picker.setToRecipients(["media@harbrapp.com"])
        picker.setMessageBody("Username: \(PFUser.currentUser()!.username!) \n I would like to be an ambassador", isHTML: true)
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)

        
    }
    

}
