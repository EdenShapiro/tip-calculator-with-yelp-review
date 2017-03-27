//
//  YelpClient.swift
//  SuperCoolTipCalculator
//
//  Created by Eden on 3/6/17.
//  Copyright © 2017 Eden Shapiro. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

//import AFNetworking
var consumerKey = "xd-t2iYRRdwUrHw2HwipLw"
var consumerSecret = "px9oATTwDkq5UTmvWzxzavE4itc"
var token = "M1vAa08Og5l0WOWNYo2sNwUGcx_x3Ige"
var tokenSecret = "M1R5bDSa3YERnNHCr2tdGSACKrg"

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}


class YelpClient: BDBOAuth1RequestOperationManager {

    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: token, accessSecret: tokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    

    //https://www.yelp.com/search?find_desc=&find_loc=Mountain+View%2C+CA&ns=1
    
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, userLocation: nil, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(_ term: String, userLocation: (Double, Double)?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
//        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]
        
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "\(userLocation!.0),\(userLocation!.1)" as AnyObject]

        
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        parameters["limit"] = 7 as AnyObject?
        
        print(parameters)
        
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}




//#import "NSURLRequest+OAuth.h"
//
//#import <TDOAuth/TDOAuth.h>
//
///**
// OAuth credential placeholders that must be filled by each user in regards to
// http://www.yelp.com/developers/getting_started/api_access
// */
//#warning Fill in the API keys below with your developer v2 keys.
//static NSString * const kConsumerKey       = @"";
//static NSString * const kConsumerSecret    = @"";
//static NSString * const kToken             = @"";
//static NSString * const kTokenSecret       = @"";
//
//@implementation NSURLRequest (OAuth)
//
//+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path {
//    return [self requestWithHost:host path:path params:nil];
//    }
//    
//    + (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
//        if ([kConsumerKey length] == 0 || [kConsumerSecret length] == 0 || [kToken length] == 0 || [kTokenSecret length] == 0) {
//            NSLog(@"WARNING: Please enter your api v2 credentials before attempting any API request. You can do so in NSURLRequest+OAuth.m");
//        }
//        
//        return [TDOAuth URLRequestForPath:path
//            GETParameters:params
//            scheme:@"https"
//        host:host
//        consumerKey:kConsumerKey
//        consumerSecret:kConsumerSecret
//        accessToken:kToken
//        tokenSecret:kTokenSecret];
//}
//
//@end
