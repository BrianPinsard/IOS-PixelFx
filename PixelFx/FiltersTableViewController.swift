//
//  FiltersTableViewController.swift
//  PixelFx
//
//  Created by SpexX on 10/01/16.
//  Copyright © 2016 Brian Pinsard. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController {
    
    var filterNames: [String] = Filters.getNames()
    var selectedFilter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filters"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        
        let filterName = filterNames[indexPath.row]
        cell.textLabel?.text = filterName.substringFromIndex(filterName.startIndex.advancedBy(2))
        
        let properties = Filters.properties[filterName]!
        cell.detailTextLabel?.text = properties != nil ? "Adjustable" : "Basic"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        selectedFilter = filterNames[index]
    }
}
