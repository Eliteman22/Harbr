//
//  YelpSearchTableViewController.swift
//  
//
//  Created by Flavio Lici on 8/6/15.
//
//

import UIKit
import CoreData
import CoreLocation




class YelpSearchTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, FoursquareAPIProtocol, CLLocationManagerDelegate {
    
    let api = FoursquareAPI()
    let locationManager = CLLocationManager()
    
    var venues = [Venue]()
    
    @IBOutlet var searchYelp: UITextField!
    
    var timelineData: NSMutableArray! = NSMutableArray()
    
    var accessToken: String!
    var accessSecret: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startUpdatingLocation()

        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
    }
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        let location = getLatestMeasurementFromLocations(locations)
        
        if isLocationMeasurementNotCached(location) && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
            findVenues(location)
        }
    }
    
    func locationManager(manager:CLLocationManager!, didFailWithError error:NSError!) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1]as! CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        return location.horizontalAccuracy >= 0
    }
    
    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
        return location.horizontalAccuracy <= locationManager.desiredAccuracy
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecieveVenues(results: [Venue]) {
        venues = results
        
        tableView.reloadData()
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func findVenues(location:CLLocation) {
        api.delegate = self
        api.searchForCofeeShopsAtLocation(location)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searcFourSquare", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    @IBAction func searchForResults(sender: UIButton) {
        
        if searchYelp.text != nil {
            
            
            print(venues)
        }
    }
    
    
    
    
    func alert(tite: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    


}

