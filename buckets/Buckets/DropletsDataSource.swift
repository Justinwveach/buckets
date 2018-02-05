//
//  DropletsDataSource.swift
//  Buckets
//
//  Created by Justin Veach on 1/29/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CoreData

class DropletsDataSource: NSObject, UITableViewDataSource {
    
    weak var parent: DropletsViewController!

    init(parent: DropletsViewController) {
        super.init()
        self.parent = parent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parent.droplets!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DropletTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DropletCellIdentifier") as! DropletTableViewCell
        
        let droplet = self.parent.droplets![indexPath.row] as! Droplet
        cell.lblTitle.text = droplet.name
        cell.tag = indexPath.row
        
        if (droplet.picked)
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
