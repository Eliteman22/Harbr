//
//  DateAndTimeSelectorViewController.swift
//  
//
//  Created by Flavio Lici on 7/1/15.
//
//

import UIKit



class DateAndTimeSelectorViewController: UIViewController, UIPickerViewDelegate {
    
    var today = true
    
    @IBOutlet var myDatePicker: UIDatePicker!
    
    @IBOutlet var chosenDate: UILabel!
    
    @IBOutlet var chosenTime: UILabel!
    
    var eventName: String!
    
    var eventType: String!
    
    var eventDescription: String!
    
    var chosenTimeString: String!
    
    @IBOutlet var Day: UILabel!
    
    var date: String = ""
    
    var time: String = ""
    
    var changeText = true

    

    override func viewDidLoad() {
        

        super.viewDidLoad()

        myDatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        let currentDate = NSDate()
        myDatePicker.minimumDate = currentDate
        myDatePicker.date = currentDate
        myDatePicker.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myDateView(sender: UIDatePicker) {
        printDate(sender.date)
    }
    
    @IBAction func todayVSFuture(sender: AnyObject) {
            myDatePicker.datePickerMode = .DateAndTime
        
        
    }
    
    
    func printDate(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        chosenDate.text = dateFormatter.stringFromDate(date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dateToImageSubmit" {
            let vc = segue.destinationViewController as! UploadEventImageViewController
            vc.eventName = eventName
            vc.eventType = eventType
            vc.eventDescription = eventDescription
            vc.eventType = eventType
            vc.eventTime = time
            vc.eventDate = date
            
            println(eventName)
            println(eventType)
            println(eventDescription)
            println(eventType)
            println(time)
            println(date)
            
            
        }
    }

    @IBAction func submitDate(sender: UIButton) {
        if !chosenDate.text!.isEmpty {
            
                let dateString = chosenDate.text
                if dateString != nil {
                    let seperators = NSCharacterSet(charactersInString: ",")
                    var dateArray = dateString!.componentsSeparatedByCharactersInSet(seperators)
                
                    date = dateArray[0] as String
                    
                    time = dateArray[1] as String
                    
                
            }}
        else {
            alert("Error", message: "Please enter a date and time")
        }
        
        performSegueWithIdentifier("dateToImageSubmit", sender: nil)

    }
    
    func alert(titel: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
