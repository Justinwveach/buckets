//
//  ViewController.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CoreData
import JSSAlertView
import SCLAlertView

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = BucketDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: IBActions
    
    @IBAction func addName(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir-Heavy", size: 22)!,
            kTextFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            kButtonFont: UIFont(name: "Avenir-Heavy", size: 16)!,
            showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        let txt = alertView.addTextField("New Bucket")
        alertView.addButton("Create Bucket") {
            if (!((txt.text?.isEmpty)!)) {
                BucketStore.sharedInstance.saveBucket(name: txt.text!)
                self.tableView.reloadData()
            }
        }

        alertView.showEdit("New Bucket", subTitle: "What kind of fun things are gonna go in this bucket?", closeButtonTitle: "Cancel", duration: 300, colorStyle: 0x65B5FC, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewDropletsSegue") {
            let btn = sender as! UIButton
            let index = btn.tag
            
            let bucketStore = BucketStore.sharedInstance
            let bucket: Bucket = bucketStore.buckets[index] as! Bucket
            
            let vc: DropletsViewController = segue.destination as! DropletsViewController
            vc.parentVC = self
            vc.set(bucket: bucket)
        }
    }
    
    public func reload() {
        BucketStore.sharedInstance.reload()
        self.tableView.reloadData()
    }
    
    public func pickedDroplet(name: String) {
        if (name == "") {
            JSSAlertView().show(
                self,
                title: "You've emptied this bucket",
                text: "Add some more droplets!",
                buttonText: "Ok"
            )
        }
        else
        {
            JSSAlertView().show(
                self,
                title: "And the winner is...",
                text: "\(name)",
                buttonText: "👍"
            )
        }
        
        self.tableView.reloadData()
    }
    
    public func reloadData() {
        self.tableView.reloadData()
    }

}

