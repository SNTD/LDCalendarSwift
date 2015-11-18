//
//  ViewController.swift
//  LDCalendarSwift
//
//  Created by lidi on 11/18/15.
//  Copyright © 2015 lidi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var seletedDays:[NSTimeInterval] = []
    var calendar : LDCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "LDCalendar"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CalendarCell")!
        let showLab = cell.contentView.viewWithTag(100) as! UILabel
        showLab.text = "今天"
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if calendar == nil {
            calendar = LDCalendar.init(frame: self.view.frame)
            self.view.addSubview(calendar)
            
            calendar.complete = { (result) -> Void in
                print("\(result)")
            }
        }
        
        calendar.show()
    }
}

