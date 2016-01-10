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
        cell.textLabel?.text = CIFilter.localizedNameForFilterName(filterName)
        
        let properties = Filters.properties[filterName]!
        cell.detailTextLabel?.text = properties != nil ? "Adjustable" : "Basic"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let infoFilter = filterNames[index]
        
        let alertController = UIAlertController(
            title: (CIFilter.localizedNameForFilterName(infoFilter) ?? "Unknown") + " details",
            message: CIFilter.localizedDescriptionForFilterName(infoFilter),
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        selectedFilter = filterNames[index]
    }
}
