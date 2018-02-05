//
//  DropletsViewController.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class DropletsViewController: UIViewController, UITableViewDelegate {
    var bucket: Bucket?
    var droplets: NSMutableOrderedSet!
    var dataSource: DropletsDataSource!
    var parentVC: ViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction
    override func viewDidLoad() {
        self.tableView.delegate = self;
        self.dataSource = DropletsDataSource.init(parent: self)
        self.tableView.dataSource = self.dataSource
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
                self.parentVC.reloadData()
                self.tableView .reloadData()
            }
        }
        
        alertView.showEdit("New Droplet", subTitle: "What do you want to add to \(bucket.name!)?", closeButtonTitle: "Cancel", duration: 300, colorStyle: 0xE11218, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func set(bucket: Bucket) {
        self.bucket = bucket
        self.droplets = bucket.mutableOrderedSetValue(forKey: "droplets")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let droplet: Droplet = self.droplets[indexPath.row] as! Droplet;
        BucketStore.sharedInstance.setDroplet(picked: droplet.picked ? false : true, droplet: droplet)
        self.tableView.reloadData();
        parentVC.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let droplet: Droplet = self.droplets[indexPath.row] as! Droplet;
            BucketStore.sharedInstance.delete(droplet: droplet);
            self.tableView.reloadData()
            parentVC.reloadData()
        }
    }
    
    
}
