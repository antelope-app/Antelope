//
//  DashboardController.swift
//  Antelope
//
//  Created by Jae Lee on 10/7/15.
//  Copyright © 2015 AdShield. All rights reserved.
//

import UIKit
import Cocoa

class DashboardController: UITableViewController {
    var tableView: UITableView = UITableView()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(tableView: UITableView!, numberOfSectionsInTableView section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {

        var cell: UITableViewCell? = tableView.dequeue
    }
}
