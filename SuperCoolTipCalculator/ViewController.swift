//
//  ViewController.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 2/3/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import UIKit
import CoreLocation
import Kanna
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var leaveYelpReviewButton: UIButton!
    let defaults = UserDefaults.standard
    var tipPercentages: [Double]!
    var defaultSegment: Int!
    var locationManager: CLLocationManager!
    var businesses: [Business]?
    var userLocation: CLLocation?
    var currentBusiness: Business?
    
//    func locationManager() -> CLLocationManager {
//        if locationManager {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//            // We don't want to be notified of small changes in location, preferring to use our
//            // last cached results, if any.
//            locationManager.distanceFilter = 50
//        }
//        return locationManager
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
           }
    
    override func viewWillAppear(_ animated: Bool) {
        if let defaultsArray = defaults.array(forKey: "tipPercentages"){
            tipPercentages = defaultsArray as! [Double]
            print("app has run before")
        } else {
            tipPercentages = [0.15, 0.20, 0.25]
            defaults.set(tipPercentages, forKey: "tipPercentages")
            print("first app run ever")
        }
        
        let segment1 = String(Int(tipPercentages[0]*100)) + "%"
        let segment2 = String(Int(tipPercentages[1]*100)) + "%"
        let segment3 = String(Int(tipPercentages[2]*100)) + "%"
        tipControl.setTitle(segment1, forSegmentAt: 0)
        tipControl.setTitle(segment2, forSegmentAt: 1)
        tipControl.setTitle(segment3, forSegmentAt: 2)
        
        if let segment = defaults.value(forKey: "defaultSegment"){
            defaultSegment = segment as! Int
        } else {
            defaultSegment = 1
        }
        tipControl.selectedSegmentIndex = defaultSegment
        
        determineMyCurrentLocation()
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            print("startUpdatingLocation")
            //locationManager.startUpdatingHeading()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("didUpdateLocations callllled")
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation!.coordinate.latitude)")
        print("user longitude = \(userLocation!.coordinate.longitude)")
        
        
        if let userLocation = userLocation {
            
            let lat = userLocation.coordinate.latitude
            let long = userLocation.coordinate.longitude
            Business.searchWithTerm(term: "", userLocation: (lat, long), sort: YelpSortMode.distance, categories: nil, deals: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                self.businesses = businesses
                if let businesses = businesses {
                    //                    for business in businesses {
                    //                        print(business.name!)
                    //                        print(business.address!)
                    //                    }
                    self.currentBusiness = businesses[0]
                    print(self.currentBusiness!.name!)
                    //                    let titleString = NSAttributedString(string: "Leave Yelp review for \(self.currentBusiness.name!)" , attributes: [String : Any]?)
                    
                    self.leaveYelpReviewButton.setTitle("Leave Yelp review for \(self.currentBusiness!.name!)", for: .normal)
                    
                }
            })
            
            
        } else {
            print("errrrrrreerer")
        }

        
//        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }



    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Called when segmentedcontrol value changes
    @IBAction func calculateTip(_ sender: AnyObject) {
//        let tipPercentages = [0.15, 0.20, 0.25]
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        defaults.set(tipControl.selectedSegmentIndex, forKey: "defaultSegment")
    }
    
    @IBAction func leaveYelpReviewButtonClicked(_ sender: Any) {
        
        let yelpReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "YelpReviewViewController") as! YelpReviewViewController
//        yelpReviewViewController.delegate = self
        yelpReviewViewController.yelpBusinessString = getYelpBusinessReviewLink()
        //        GISVC.webView = UIWebView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
        self.present(yelpReviewViewController, animated: true, completion: nil)
        
    
    }
    
    func getYelpBusinessReviewLink() -> String {
        
        return ""
    }
    
    
    func scrapeYelpPage(_ businessName: String) -> Void {
        
        Alamofire.request("http://nycmetalscene.com").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(_ html: String) -> Void {
        // Finish this next
    }
    
}
    /* Example of Yelp search with more search options specified
     Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
     self.businesses = businesses
     
     for business in businesses {
     print(business.name!)
     print(business.address!)
     }
     }
     */
    
    //        Business.searchWithTerm(term: "", sort: .Distance, completion: { (businesses: [Business]?, error: Error?) -> Void in
    //
    //            self.businesses = businesses
    //            if let businesses = businesses {
    //                for business in businesses {
    //                    print(business.name!)
    //                    print(business.address!)
    //                }
    //            }
    //
    //        }
    //        )
    //    }
    
//    - (void)startSignificantChangeUpdates
//
//    {
//    
//    // Create the location manager if this object does not
//    
//    // already have one.
//    
//    if (nil == locationManager)
//    
//    locationManager = [[CLLocationManager alloc] init];
//    
//    
//    
//    locationManager.delegate = self;
//    
//    [locationManager startMonitoringSignificantLocationChanges];
//    
//    }
    




