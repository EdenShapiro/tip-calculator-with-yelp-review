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
    
    @IBOutlet weak var webView: UIWebView!
    var yelpBusinessString: String!
    
//    @IBOutlet weak var longPressLabel: UIBarButtonItem!
    
    var isImage = false
    //    var imageURL: String?
    var imageSource: String?
    var imageSourceURL: URL?
    var image: UIImage?
//    override var prefersStatusBarHidden: Bool

    var delegate: WebImageDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up webview
        webView.delegate = self
        webView.isUserInteractionEnabled = true
        print(yelpBusinessString)
        let url = URL(string: yelpBusinessString)
        let request = URLRequest(url: url!)
        webView.loadRequest(request as URLRequest)
        webView.scalesPageToFit = true
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(GISViewController.handleLongPress(_:)))
//        longPressRecognizer.delegate = self
//        webView.addGestureRecognizer(longPressRecognizer)
//        
//        let fontAttributes = [
//            NSStrokeColorAttributeName : UIColor(red:0.10, green:0.24, blue:0.41, alpha:1.0),//Fill in appropriate UIColor for outline color
//            NSForegroundColorAttributeName : UIColor(red:0.22, green:0.45, blue:0.73, alpha:1.0), //Fill in UIColor for text color
//            NSFontAttributeName : UIFont(name: "Futura", size: 15)!,
//            NSStrokeWidthAttributeName : -3.0 //Fill in appropriate Float for what percentage of the character should be outline
//        ]
        
//        longPressLabel.enabled = false
//        longPressLabel.setTitleTextAttributes(fontAttributes, forState: .Disabled)
        
//        prefersStatusBarHidden()
        
        webView.reload()
        //          longPressLabel.setAttributedTitle(NSAttributedString(string: "Done", attributes: fontAttributes), forState: .Normal)
        
        
        //        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GISViewController.handleTap(_:)))
        //        tapRecognizer.delegate = self
        
    }
    
    func returnImage() {
        print("returnImage called")
        //        let imageData = NSData(contentsOfURL: imageSourceURL!)
        self.delegate.sendWebImage(image!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //   if mything is an image,      myThing.addGestureRecognizer(longPressRecognizer)
        
        //        webView.stringByEvaluatingJavaScriptFromString("document.body.style.webkitTouchCallout='none';")
        
        
    }
    
    @IBAction func doRefresh(_: AnyObject) {
        
        webView.reload()
        
    }
    
    
    
    @IBAction func goBack(_: AnyObject) {
        
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    @IBAction func goForward(_: AnyObject) {
        if webView.canGoForward {
            webView.goForward()
        }
        
    }
    
    
    
    @IBAction func stop(_: AnyObject) {
        
        webView.stopLoading()
        
    }
    
    
    
//    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
//        print("inside of handlelongpress")
//        if let recognizerView = recognizer.view {
//            let loc = recognizer.locationInView(recognizerView)
//            if let subview = view.hitTest(loc, withEvent: nil){ // note: it is a `UIView?`
//                
//                subview.becomeFirstResponder()
//                // create the little popup menu thing with delete/copy/etc buttons
//                
//                
//                guard let stringImageSource = webView.stringByEvaluatingJavaScriptFromString(imageSource!)
//                    else {
//                        print("we've got a stringByEvaluatingJavaScriptFromString problem")
//                        return
//                }
//                print("stringByEvaluatingJavaScriptFromString works and the string is \(stringImageSource)")
//                
//                guard let URLFromString = NSURL(string: stringImageSource)
//                    else { print("cannot form URL from string")
//
//                        return           }
//                guard let imageData = NSData(contentsOfURL: URLFromString)
//                    else { print("cannot form NSData from URL")
//                        return  }
//                guard let theImage = UIImage(data: imageData)
//                    else { print("cannot form image from data")
//                        return
//                }
//                image = theImage
//                //            isImage = true
//                print("isImage is true")//and urlToSave :\(stringImageSource)")
//                print("is image")
//                
//                let menuController = UIMenuController.sharedMenuController()
//                menuController.setTargetRect(subview.frame, inView: self.view)
//                let menuItem = UIMenuItem(title: "Use image", action: #selector(self.returnImage))
//                menuController.menuItems = [menuItem]
//                menuController.setMenuVisible(true, animated:true)
//
//            }
//        }
//        
//    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //        print("gesture recog method called")
        return true
    }
    
    //    @available(iOS 9.0, *)
    //    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceivePress press: UIPress) -> Bool {
    //        return true
    //    }
    
//    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        
//        if action == #selector(self.returnImage) {
//            return true
//        }
//        
//        return false
//    }
    
    //    func handleTap(recognizer: UITapGestureRecognizer){
    //
    //    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        print("inside of gesturerecognizer method")
//        if (gestureRecognizer is UILongPressGestureRecognizer) {
//            print("is long press")
//            let touchPoint = touch.locationInView(self.view)
//            imageSource = "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"
//            print("imageSource is: \(imageSource)")
//            
//        }
//        return true
//    }
    
    
//
//    override internal func statusbar() -> Bool {
//        return true
//    }
    
}

protocol WebImageDataDelegate {
    //    func sendWebImageData(data: NSData)
    func sendWebImage(_ image: UIImage)
    
}
