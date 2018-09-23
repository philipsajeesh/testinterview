//
//  APIManager.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class APIManager: NSObject {
    
    /// Fetch the data from API using alamofire
    class func fetchData(url:String, completion: @escaping (Bool,JSON?,Int?,String) -> Void) {
        Alamofire.request(url)
            .responseJSON { response in
                let reposeData = response.result.value
                let json = JSON(reposeData as Any) as JSON
                print(json)
                var status = false
                let statusCode = response.response?.statusCode
                print("Status code:  \(String(describing: statusCode))")
                var errorMessage = ""
                if((response.result.error != nil)) {
                    errorMessage = (response.result.error?.localizedDescription)!
                    status = false
                }else{
                    status = true
                }
                if let mesage = json["message"].string{
                    errorMessage = mesage
                }
                completion(status, json , statusCode, errorMessage)
        }
        
    }

}
