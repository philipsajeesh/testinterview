//
//  CoreDataHelper.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import CoreData

/// Core data helper class to manage data

class CoreDataHelper: NSObject {
    static var  managedObjectContext: NSManagedObjectContext?
    
    /// Save context
    class func saveManagedObjectContext()->(status : Bool, message: String?){
        var error: NSError?
        do {
            try managedObjectContext!.save()
            return (true,error?.localizedDescription)
        } catch let error1 as NSError {
            error = error1
            print(error.debugDescription)
            return (false,error?.localizedDescription)
        }
    }
    
    /// Delete context
    class func deleteManagedObjectContext(_ object :NSManagedObject)-> (status:Bool,message:String?) {
        managedObjectContext?.delete(object)
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            return (false , error?.localizedDescription)
        }
        return (true,nil)
    }
    
    /// Insert to Collection
    class func insertToCollection(name:String?) -> Collection{
        let newCollection:Collection = Collection(context: self.managedObjectContext!)
            newCollection.name = name
            newCollection.lastUpdated = Date().startOfDay
        return newCollection
    }
    
    /// Insert to Story
    class func inserToStory(headline:String?,author:String?,summary:String?,imageUrl:String?,sectionId:Int16,collection:Collection?){
        let newStory:Story = Story(context: self.managedObjectContext!)
            newStory.headline = headline
            newStory.authorName = author
            newStory.summary = summary
            newStory.heroImageURL = imageUrl
            newStory.sectionId = sectionId
            newStory.collection = collection
            _ = saveManagedObjectContext()
    }
    
    /// Fetch collection
    class func fetcjCollections()->Collection? {
        let fetchRequest: NSFetchRequest<Collection> =  Collection.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchLimit = 1
        let items:NSArray = try! managedObjectContext!.fetch(fetchRequest) as NSArray
        if(items.count > 0){
            return  items[0] as? Collection
        }else{
            return nil
        }
    }
    
    /// Fetch story
    class func fetchStories()->NSArray? {
        let fetchRequest: NSFetchRequest<Story> =  Story.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let items:NSArray = try! managedObjectContext!.fetch(fetchRequest) as NSArray
        return items
    }

    /// Clear everything
    class func clearStore(){
        let results = fetchStories()
        if (results?.count)!>0 {
            for result: Any in results!
            {
                _ = deleteManagedObjectContext(result as! NSManagedObject)
            }
            _ = saveManagedObjectContext()
        }
    }
}
