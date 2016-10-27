//
//  Intro2ViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class Intro2ViewController: UIViewController {

    @IBOutlet weak var imageToPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToPost.alpha = 0
        
        UIView.animateWithDuration(1.0, animations: {
            self.imageToPost.alpha = 1
        })
        
        self.navigationController?.navigationBarHidden = true 

        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        recognizer.direction = .Left
        self.view.addGestureRecognizer(recognizer)
        
        let backRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        backRecognizer.direction = .Right
        self.view.addGestureRecognizer(backRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("intro2ToIntro3", sender: self)
    }
    
    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
 
    @IBAction func goBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    

}
