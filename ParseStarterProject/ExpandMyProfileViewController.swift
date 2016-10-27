//
//  ExpandMyProfileViewController.swift
//  
//
//  Created by Flavio Lici on 7/8/15.
//
//

import UIKit
import Parse

class ExpandMyProfileViewController: UIViewController {

    @IBOutlet var numberOfPoints: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if PFUser.currentUser()!.objectForKey("Points") == nil {
            numberOfPoints.text = "0"
        } else {
            let myPoints = PFUser.currentUser()!.objectForKey("Points") as? Int
            numberOfPoints.text = "\(myPoints!)"
        }

    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func deleteAccount(sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {
            (action) -> Void in
            
            PFUser.currentUser()!.delete()
            self.performSegueWithIdentifier("accountDelete", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
