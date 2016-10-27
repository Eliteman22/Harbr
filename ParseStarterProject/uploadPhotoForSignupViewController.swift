//
//  uploadPhotoForSignupViewController.swift
//  
//
//  Created by Flavio Lici on 8/22/15.
//
//

import UIKit
import Parse

class uploadPhotoForSignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var uploadPhoto: UIButton!
    
    @IBOutlet var buttonAlpha: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToPost.contentMode = UIViewContentMode.ScaleAspectFill
        imageToPost.clipsToBounds = true
        
        buttonAlpha.userInteractionEnabled = false
        buttonAlpha.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadProPic(sender: UIButton) {
        if imageToPost.image != nil {
            let imageData = imageToPost.image
            let imageFile: PFFile = PFFile(name: "propic.png", data: UIImageJPEGRepresentation(imageData, 0.8))
            PFUser.currentUser()?.setObject(imageFile, forKey: "ProfilePic")
            self.performSegueWithIdentifier("submitProPicSeg", sender: self)
        } else {
            displayAlert("Error", message: "Please enter an image")
        }
        
    }
    
    @IBAction func showProPic(sender: UIButton) {
        
        var image = UIImagePickerController()
        image.delegate = self
        let alertController = UIAlertController(title: "Where would you like to upload from", message: "Choose: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
            (action) in
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
            self.performSegueWithIdentifier("submitProPicSeg", sender: self)
            
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (action) in
            
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            self.presentViewController(image, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("submitProPicSeg", sender: self)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
         self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        UIView.animateWithDuration(0.8, animations: {
            self.buttonAlpha.alpha = 1
            self.buttonAlpha.userInteractionEnabled = true
        })
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
            (action) -> Void in
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
        
}
