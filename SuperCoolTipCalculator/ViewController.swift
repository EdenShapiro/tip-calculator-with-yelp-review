//
//  ViewController.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 2/3/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Kanna
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var leaveYelpReviewButton: UIButton!
    @IBOutlet weak var incorrectLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var currentBusiness: Business?
    var tipPercentages: [Double]!
    var defaultSegment: Int!
    var businesses: [Business]?
    var yelpBusinessReviewLink: String?
    let defaults = UserDefaults.standard
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFormatterAndBillField()
        checkDefaultsForValue()
        activityIndicator.isHidden = true
        billField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
        billField.addTarget(self, action: #selector(calculateTip), for: .editingChanged)
        billField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .valueChanged)
        tipControl.addTarget(self, action: #selector(calculateTip), for: .valueChanged)
    }
    
    func setUpFormatterAndBillField(){
        billField.delegate = self
        billField.becomeFirstResponder()
        billField.keyboardType = .numberPad
        billField.textAlignment = .right
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencySymbol = Locale.current.currencySymbol!
        formatter.currencyCode = Locale.current.currencyCode!
    }
    
    func checkDefaultsForValue(){
        let currentTime = NSDate()
        print("in checkDefaultsForValue")
        if let lastUsed = defaults.object(forKey: "lastUsed") {
            
            let timeSinceLastUsed = currentTime.timeIntervalSinceReferenceDate - (lastUsed as! NSDate).timeIntervalSinceReferenceDate
            print(timeSinceLastUsed)
            if timeSinceLastUsed > 600 {
                defaults.removeObject(forKey: "billField")
                defaults.synchronize()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up segmentedcontrol
        setUpSegmentedControl()
        
        
        // Persist selected segment
        if let segment = defaults.value(forKey: "defaultSegment"){
            defaultSegment = segment as! Int
        } else {
            defaultSegment = 1
        }
        tipControl.selectedSegmentIndex = defaultSegment
        
        
        // Check billField for prior value
        if let billField = defaults.string(forKey: "billField"){
            self.billField.text = billField
            textFieldChanged(textField: self.billField)
        } else {
            self.billField.text = formatter.currencySymbol!
        }
        calculateTip()
        
        
        // Determine current user location
        determineMyCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        let lastUsed = NSDate()
        defaults.set(lastUsed, forKey: "lastUsed")
        if let billField = self.billField.text {
            print(billField)
            defaults.set(billField, forKey: "billField")
        }
        defaults.synchronize()
        billField.resignFirstResponder()
    }

    func setUpSegmentedControl(){
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
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            print("startUpdatingLocation")
        }
    }
    
    // Updated location callback
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("didUpdateLocations called")
        // TODO: Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation!.coordinate.latitude)")
        print("user longitude = \(userLocation!.coordinate.longitude)")
        
        if let userLocation = userLocation {
            
            let lat = userLocation.coordinate.latitude
            let long = userLocation.coordinate.longitude
            Business.searchWithTerm("", userLocation: (lat, long), sort: YelpSortMode.distance, categories: nil, deals: nil, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                self.businesses = businesses
                if let businesses = businesses {
                    self.currentBusiness = businesses[0]
                    print(self.currentBusiness!.name!)
                    //  TODO: make button prettier. let titleString = NSAttributedString(string: "Leave Yelp review for \(self.currentBusiness.name!)" , attributes: [String : Any]?)
                    self.setLeaveYelpReviewButton(business: self.currentBusiness!)
                }
            })
            
        } else {
            print("Error: userLocation not found.")
        }
    }
    
    func setLeaveYelpReviewButton(business: Business){
        self.leaveYelpReviewButton.setTitle("Leave Yelp review for \(business.name!)", for: .normal)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Called when segmentedcontrol value changes or when bill textfield changed
    func calculateTip() {
        let text = billField.text?.replacingOccurrences(of: formatter.currencySymbol, with: "").replacingOccurrences(of: formatter.groupingSeparator, with: "").replacingOccurrences(of: formatter.decimalSeparator, with: "")
        
        let double = Double(text!) ?? 0
        let bill = Double(double/100.0)
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = formatter.string(from: NSNumber(value: tip))!
        totalLabel.text = formatter.string(from: NSNumber(value: total))!
        
        defaults.set(tipControl.selectedSegmentIndex, forKey: "defaultSegment")
        
        
        //TODO: Maybe add animations later? It doesn't seem to add much to the app right now.
        //        self.firstView.alpha = 0
        //        self.secondView.alpha = 1
        //        UIView.animateWithDuration(0.4, animations: {
        //            // This causes first view to fade in and second view to fade out
        //            self.firstView.alpha = 1
        //            self.secondView.alpha = 0
        //        })
    }
    
    func textFieldChanged(textField: UITextField) {
        let text = textField.text?.stringOfNumbersOnly
        print("cleaned up text: \(text)")
        textField.text = formatter.string(from: NSNumber(value: (Double(text!) ?? 0)/100.0))
        print("newly reformated text: \(textField.text)")
    
    }
    
    @IBAction func leaveYelpReviewButtonClicked(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let currentBusinessLink = Constants.YelpHost + Constants.YelpBizPath + "/" + self.currentBusiness!.id!
        print(currentBusinessLink)
        scrapeYelpPage(requestLink: currentBusinessLink) { () in
            let yelpReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "YelpReviewViewController") as! YelpReviewViewController
            print(self.yelpBusinessReviewLink!)
            self.yelpBusinessReviewLink!.remove(at: self.yelpBusinessReviewLink!.index(before: self.yelpBusinessReviewLink!.endIndex))
            self.yelpBusinessReviewLink!.remove(at: self.yelpBusinessReviewLink!.index(before: self.yelpBusinessReviewLink!.endIndex))
            yelpReviewViewController.yelpBusinessString = self.yelpBusinessReviewLink!
            self.navigationController?.pushViewController(yelpReviewViewController, animated: true)
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func incorrectLocationButtonClicked(_ sender: Any) {
        let otherLocationsVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherLocationsViewController") as! OtherLocationsViewController
        otherLocationsVC.parentVC = self
        if let otherLocs = self.businesses {
            otherLocationsVC.otherBusinessesArray = otherLocs
            print("Here is the list of other locations: \(otherLocs)")
        } else {
            otherLocationsVC.otherBusinessesArray = [Business]()
            //TODO: Create some label that displays when no nearby businesses are found
            print("There are no other businesses in the area or something went wrong.")
        }
        
        self.navigationController?.pushViewController(otherLocationsVC, animated: true)
    }
    
    
    func scrapeYelpPage(requestLink: String, completion: @escaping () -> Void ) {
        Alamofire.request(requestLink).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html) { () in
                    completion()
                }
            }
        }
    }
    
    func parseHTML(_ html: String, completionHandler: () -> Void) {

            let regex = try! NSRegularExpression(pattern: "\\/writeareview\\/biz\\/.+\\?return_url.+",
                                                 options: .caseInsensitive)
            guard let myMatch = regex.firstMatch(in: html, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: html.characters.count))
                else {
                    print("Error in parseHTML")
                    return
                }
            let tmp = (html as NSString).substring(with: myMatch.range)
            print("Match: \(tmp)")
            self.yelpBusinessReviewLink = Constants.YelpHost + tmp
            completionHandler()

    }
    
}

extension String {
    
    var stringOfNumbersOnly: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
