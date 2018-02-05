//
//  BucketTableViewCell.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class BucketDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BucketStore.sharedInstance.getBuckets().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BucketTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BucketCellIdentifier") as! BucketTableViewCell
        
        let store = BucketStore.sharedInstance
        let bucket: Bucket = store.getBuckets()[indexPath.row]
        let dropsLeft: Int = self.getDropletsLeft(bucket: bucket)

        cell.lblTitle.text = bucket.name
        
        let mainColor: UIColor = (bucket.color as! UIColor?)!
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        mainColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let d: CGFloat = (20/255.0)
        let secondColor: UIColor = UIColor.init(red: r-d, green: g-d, blue: b-d, alpha: 1.0)
        cell.toolbar.barTintColor = secondColor
        
        cell.vBackground.backgroundColor = bucket.color as! UIColor?
        cell.lblTotalDroplets.text = "\(bucket.droplets!.count) Total Droplets"
        cell.lblDropletsLeft.text = "\(dropsLeft)"
        
        cell.tag = indexPath.row
        cell.btnAddDroplet.tag = indexPath.row
        cell.btnViewDroplets.tag = indexPath.row
        cell.btnDeleteBucket.tag = indexPath.row
        cell.btnPickDroplet.tag = indexPath.row
        
        return cell
        
    }
    
    func getDropletsLeft(bucket: Bucket) -> Int {
        var count = 0
        let dropletCount: Int = (bucket.droplets?.count)!
        for i in 0 ..< dropletCount
        {
            let droplet: Droplet = bucket.droplets![i] as! Droplet
            if (!droplet.picked)
            {
                count += 1
            }
        }
        
        return count
    }
    
}
