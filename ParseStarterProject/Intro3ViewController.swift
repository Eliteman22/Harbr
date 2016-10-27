//
//  Intro3ViewController.swift
//  Harbr
//
//  Created by Flavio Lici on 9/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class Intro3ViewController: UIViewController {
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var imageToPost: UIImageView!

    override func viewDidLoad() {
        
        imageToPost.alpha = 0
        finishButton.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: {
            self.imageToPost.alpha = 1
            
        })
        
        UIView.animateWithDuration(2.0, animations: {
            self.finishButton.alpha = 1
        })
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        recognizer.direction = .Left
        self.view .addGestureRecognizer(recognizer)
        
        let backRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        backRecognizer.direction = .Right
        self.view.addGestureRecognizer(backRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backtoSecond(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func backToFirst(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.popViewControllerAnimated(true)
    }
    

}
