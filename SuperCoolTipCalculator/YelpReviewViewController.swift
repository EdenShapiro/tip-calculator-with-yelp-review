//
//  YelpReviewViewController.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 3/24/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import Foundation
import UIKit


class YelpReviewViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var yelpBusinessString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        // Set up webview
        webView.delegate = self
        webView.isUserInteractionEnabled = true
        print(yelpBusinessString)
        let url = URL(string: yelpBusinessString)
        let request = URLRequest(url: url!)
        webView.loadRequest(request as URLRequest)
        webView.scalesPageToFit = true
        webView.reload()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }

}
