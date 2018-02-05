//
//  BucketTableViewCell.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import SCLAlertView
import JSSAlertView

class BucketTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddDroplet: UIBarButtonItem!
    @IBOutlet weak var btnViewDroplets: UIButton!
    @IBOutlet weak var lblDropletsLeft: UILabel!
    @IBOutlet weak var lblTotalDroplets: UILabel!
    @IBOutlet weak var btnDeleteBucket: UIBarButtonItem!
    @IBOutlet weak var btnPickDroplet: UIButton!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func addDroplet(_ sender: Any) {
        let btn = sender as! UIBarButtonItem
        let index = btn.tag
        
        let bucketStore = BucketStore.sharedInstance
        let bucket: Bucket = bucketStore.buckets[index] as! Bucket
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir-Heavy", size: 22)!,
            kTextFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            kButtonFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)

        let txt = alertView.addTextField("New Droplet")
        alertView.addButton("Add It To The Bucket") {
            if (!((txt.text?.isEmpty)!)) {
                BucketStore.sharedInstance.add(dropletName: txt.text, bucket: bucket)
                let vc: ViewController = self.getParent()
                vc.reload()
            }
        }
        
        alertView.showEdit("New Droplet", subTitle: "What do you want to add to \(bucket.name!)?", closeButtonTitle: "Cancel", duration: 300, colorStyle: 0xE11218, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
    }
    
    @IBAction func deleteBucket(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir-Heavy", size: 22)!,
            kTextFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            kButtonFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Delete Bucket") {
            let btn = sender as! UIBarButtonItem
            let index = btn.tag
            
            let bucket: Bucket = BucketStore.sharedInstance.buckets[index] as! Bucket
            BucketStore.sharedInstance.delete(bucket: bucket)
            
            let vc: ViewController = self.getParent()
            vc.reload()
        }
        
        alertView.showEdit("Delete Bucket", subTitle: "Are you sure you want to delete this bucket and all the droplets it contains?", closeButtonTitle: "Cancel", duration: 300, colorStyle: 0xE11218, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)

    }
    
    @IBAction func pickDroplet(_ sender: Any) {
        self.animateBucket()
        
        let btn = sender as! UIButton
        let index = btn.tag
        let bucketStore = BucketStore.sharedInstance
        let bucket: Bucket = bucketStore.buckets[index] as! Bucket
        
        var dropletsLeft: [Droplet] = []
        let dropletCount: Int = (bucket.droplets?.count)!
        for i in 0 ..< dropletCount
        {
            let droplet: Droplet = bucket.droplets![i] as! Droplet
            if (!droplet.picked)
            {
                dropletsLeft.append(droplet)
            }
        }
        
        let rand = Int(arc4random_uniform(UInt32(dropletsLeft.count)))
        let vc: ViewController = self.getParent()
        if (dropletsLeft.count > 0)
        {
            let droplet: Droplet = dropletsLeft[rand]
        
            BucketStore.sharedInstance.setDroplet(picked: true, droplet: droplet)
            vc.pickedDroplet(name: droplet.name!)
        }
        else
        {
            vc.pickedDroplet(name: "")
        }
    }
    
    func animateBucket() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1.0
        
//        if let delegate: AnyObject = completionDelegate {
//            rotateAnimation.delegate = delegate
//        }
        self.btnPickDroplet.layer.add(rotateAnimation, forKey: nil)
    }
    
    func getParent() -> ViewController {
        var vc: Any = self.next!
        
        while(!((vc as AnyObject).isKind(of: ViewController.self)))
        {
            vc = (vc as AnyObject).next as Any;
        }
        
        return vc as! ViewController;
    }
}
