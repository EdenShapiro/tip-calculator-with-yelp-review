//
//  OtherLocationsViewController.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 8/11/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import UIKit

class OtherLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var otherBusinessesArray: [Business]!
    var parentVC: ViewController!
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let oldCell = self.tableView.dequeueReusableCell(withIdentifier: "OtherLocationsCell"){
            cell = oldCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "OtherLocationsCell")
//           TODO: customize this. cell.selectionStyle = .none
        }
        cell.textLabel?.text = otherBusinessesArray[indexPath.row].name!
        cell.textLabel?.textColor = UIColor.darkGray
        print("Here is the cell i'd like to show: \(otherBusinessesArray[indexPath.row].name!)")
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return otherBusinessesArray.count
            // TODO: Set some label to "No other businesses found at this location" if array is empty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityIndicator.startAnimating()
        let selectedBusiness = otherBusinessesArray[indexPath.row]
        let currentBusinessLink = Constants.YelpHost + Constants.YelpBizPath + "/" + selectedBusiness.id!
        print(currentBusinessLink)
        parentVC.scrapeYelpPage(requestLink: currentBusinessLink) { () in
            let yelpReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "YelpReviewViewController") as! YelpReviewViewController
            print(self.parentVC.yelpBusinessReviewLink!)
            self.parentVC.yelpBusinessReviewLink!.remove(at: self.parentVC.yelpBusinessReviewLink!.index(before: self.parentVC.yelpBusinessReviewLink!.endIndex))
            self.parentVC.yelpBusinessReviewLink!.remove(at: self.parentVC.yelpBusinessReviewLink!.index(before: self.parentVC.yelpBusinessReviewLink!.endIndex))
            yelpReviewViewController.yelpBusinessString = self.parentVC.yelpBusinessReviewLink!
            self.parentVC.setLeaveYelpReviewButton(business: selectedBusiness)
            self.navigationController?.pushViewController(yelpReviewViewController, animated: true)
            self.activityIndicator.stopAnimating()
        }
    }


}
