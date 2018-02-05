//
//  BucketStore.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import Foundation
import CoreData

public class BucketStore {
    
    static let sharedInstance = BucketStore()
    
    public var buckets: [NSManagedObject] = []

    let managedContext: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = (appDelegate?.persistentContainer.viewContext)!
        buckets = fetch(object: "Bucket") as! [NSManagedObject]
    }
    
    func reload() {
        buckets = fetch(object: "Bucket") as! [NSManagedObject]
    }
    func fetch(object: String) -> Array<Any> {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: object)
        let retVal: Array<Any>
        
        do {
            retVal = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            retVal = []
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return retVal;
    }
    
    func getBuckets() -> Array<Bucket> {
        var buckets: [Bucket] = []
        buckets = fetch(object: "Bucket") as! [Bucket]
        return buckets
    }
    
    func saveBucket(name: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Bucket", in: managedContext)!
        
        let bucket = NSManagedObject(entity: entity, insertInto: managedContext)
        
        bucket.setValue(name, forKey: "name")
        
        let random = Int(arc4random_uniform(UInt32(Constants.allColors.count)))
        let color: UIColor = Constants.allColors[random]
        bucket.setValue(color, forKey: "color")
        
        do {
            try managedContext.save()
            buckets.append(bucket)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(bucket: Bucket) {
        self.managedContext.delete(bucket)
        saveContext()
    }
    
    func delete(droplet: Droplet) {
        self.managedContext.delete(droplet);
        saveContext();
    }
    
    func add(dropletName: String!, bucket: Bucket!) {

        let entity = NSEntityDescription.entity(forEntityName: "Droplet", in: managedContext)!
        
        let droplet = NSManagedObject(entity: entity, insertInto: managedContext)
        
        droplet.setValue(dropletName, forKey: "name")

        let droplets = bucket.mutableOrderedSetValue(forKey: "droplets")

        droplets.add(droplet)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setDroplet(picked: Bool, droplet: Droplet) {
        droplet.picked = picked
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
