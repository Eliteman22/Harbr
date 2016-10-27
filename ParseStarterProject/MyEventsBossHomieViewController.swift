//
//  MyEventsBossHomieViewController.swift
//  
//
//  Created by Flavio Lici on 8/15/15.
//
//

import UIKit

class MyEventsBossHomieViewController: UIViewController {
    
    var currentDate: String!
    
    var randomNum: Int!
    
    @IBOutlet var leftButton: UIButton!
    
    @IBOutlet var rightButton: UIButton!

    @IBOutlet var statusBarBackground: UILabel!
    
    @IBOutlet var widthOfScreen: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        currentDate = dateFormatter.stringFromDate(NSDate())
        
        widthOfScreen.constant = self.view.frame.width / 2
        
        if checkIfDay(currentDate) {
            randomNum = Int(arc4random_uniform(3)) + 1
            if 2 % randomNum == 0 {
                leftButton.setImage(UIImage(named: "dayevents1.png"), forState: .Normal)
                rightButton.setImage(UIImage(named: "dayquest2.png"), forState: .Normal)
            } else {
                leftButton.setImage(UIImage(named: "dayevents2.png"), forState: .Normal)
                rightButton.setImage(UIImage(named: "dayquest2.png"), forState: .Normal)
            }
        } else {
            randomNum = Int(arc4random_uniform(3)) + 1
            
            if 2 % randomNum == 0 {
                leftButton.setImage(UIImage(named: "nightevent2.png"), forState: .Normal)
                rightButton.setImage(UIImage(named: "nightquest1.png"), forState: .Normal)
            } else {
                
                leftButton.setImage(UIImage(named: "nightevent4.png"), forState: .Normal)
                rightButton.setImage(UIImage(named: "nightquest2.png"), forState: .Normal)
            }
            
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        self.tabBarController?.tabBar.hidden = false

    }
    
    func checkIfDay(time: String) -> Bool {
        
        var fullName = time
        let fullNameArr = fullName.componentsSeparatedByString(":")
        
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
        
        if (firstName.toInt()! > 6) && (firstName.toInt()! <= 19) {
            return true
        } else {
            return false
        }
        

    }
    

}
