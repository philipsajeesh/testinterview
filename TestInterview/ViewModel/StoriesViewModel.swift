//
//  StoriesViewModel.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import UIKit
import SwiftyJSON

/// View model
class StoriesViewModel: NSObject {
    
    /// Getting status
    var fetchDataStatus : Box<Bool> = Box(_value: false)
    var itemsArray =  [JSON]()
    /// Index of the items array
    var index:Int = 0
    /// SectionID used for the order of stories display
    var sectionId : Int16 = 0
    
    /// Check for update once in a day
    func checkForUpdate(){
        if let collection = CoreDataHelper.fetcjCollections(){
            
            /// Clear and fetch data again if today is a different day than lastUpdated
            if(Date().startOfDay.isGreaterThanDate(dateToCompare: collection.lastUpdated!)){
                CoreDataHelper.clearStore()
                
                /// API call
                self.getAPIData(url: "https://demo9639618.mockable.io/collection", collection: nil) { (status) in
                    
                }
            }else{
                
                fetchDataStatus.value = true
            }
        }else{
            /// API call
            self.getAPIData(url: "https://demo9639618.mockable.io/collection", collection: nil) { (status) in
            }
        }
    }
    
    /// API call
    private func getAPIData(url:String , collection:Collection? ,completion: @escaping (Bool) -> Void){
        APIManager.fetchData(url:url , completion: { (status, jsonData, statusCode, errorMessage) in
            if(status){
                if let json = jsonData {
                    if let jsonArray = json["items"].array {
                        if let newCollection = collection{
                            self.seedStories(items: jsonArray, collection: newCollection)
                            completion(true)
                        }else{
                            self.itemsArray = jsonArray
                            self.seedData()
                        }
                    }
                }
            }
        })
    }

    /// Seed collection and stories into Core Data based on the type
    private func seedData() {
        if index < itemsArray.count {
            let item = self.itemsArray[index]
            if item["type"].string == "collection" {
                
                /// Seed collection in to core data
                let newCollection = CoreDataHelper.insertToCollection(name: item["name"].string!)
                
                /// API call to get the stories of a collection
                getAPIData(url: item["url"].string!, collection: newCollection) { (status) in
                    self.index += 1
                    /// Recursion
                    self.seedData()
                }
                
            }
            else if item["type"].string == "story" {
                
                 /// Seed stories into Core Data
                CoreDataHelper.inserToStory(headline: item["story"]["headline"].string, author: item["story"]["author-name"].string, summary: item["story"]["summary"].string, imageUrl: item["story"]["hero-image"].string, sectionId: sectionId, collection: nil)
                sectionId += 1
                self.index += 1
                self.seedData()
            }
        }else{
            fetchDataStatus.value = true
        }
    }
    
    /// Seed stories into Core Data
    private func seedStories(items:[JSON],collection:Collection){
        for item in items{
            CoreDataHelper.inserToStory(headline: item["story"]["headline"].string, author: item["story"]["author-name"].string, summary: item["story"]["summary"].string, imageUrl: item["story"]["hero-image"].string, sectionId: sectionId, collection: collection)
        }
        sectionId += 1
    }
    
}
