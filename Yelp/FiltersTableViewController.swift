//
//  FiltersTableViewController.swift
//  Yelp
//
//  Created by Usman Ajmal on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersTableViewControllerDelegate {
    // func doSomethingWithData(data: Data)
    @objc optional func filtersTableViewController(filtersTableViewController: FiltersTableViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersTableViewController: UITableViewController {

    weak var delegate: FiltersTableViewControllerDelegate?
    var filter = [String: AnyObject]()
    // TODO: Get number section from proper datastructre like
    // a dictionaory which has all sections, their titles, number
    // of rows etc.
    let NUMBER_OF_SECTIONS = 4
    
    @IBOutlet var distanceOutletCollection: [UISwitch]!
    @IBOutlet weak var offerringDealsSwitch: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.apportionsSegmentWidthsByContent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NUMBER_OF_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // TODO:
        // Use a dictionaory which has all sections, their titles, number of rows etc.
        switch section {
            // Distance Section has 5 rows
            case 1:
                return 5
            // Categories Section has 4 rows
            case 3:
                return 4
            // Rest of the sections have 1 row
            default:
                return 1
        }
    
    }

    /**
     *  Action for cancel button. Dismiss the modal when cancel is 
     *  pressed
     */
    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        print("Cancelling...")
        dismiss(animated: true, completion: nil)
    }
    
    /**
     *  Search using updated "filter" dictionary
     */
    @IBAction func searchBtnTapped(_ sender: AnyObject) {
        // Dismiss the modal
        dismiss(animated: true, completion: nil)
        
        // Set Offering Deals option
        filter["offeringDeals"] = offerringDealsSwitch.isOn as AnyObject
        
        delegate?.filtersTableViewController?(filtersTableViewController: self, didUpdateFilters: filter)
    }
    
    /**
     *  Action outlet for all distance UISwitch
     *  Turn Off all other switch when an of those distance switches
     *  is turned On by user
     */
    @IBAction func resetSwitch(_ sender: UISwitch, forEvent event: UIEvent) {
        
        for uiSwitch in distanceOutletCollection {
            if sender != uiSwitch {
                uiSwitch.setOn(false, animated: true)
            }
        }
        
        // Set distance in filters dictionary
        // Get distance (in miles) from tags of each UISwitch
        
        // "auto" has tag 0. Tag is where we are getting distance from
        if (sender.tag == 0) {
            filter["distance"] = nil
            return
        }
        
        filter["distance"] = sender.tag as AnyObject?

    }
    
    /**
     *  Action outlet for setting Sort mode in "filter"
     */
    @IBAction func setSortMode(_ sender: UISegmentedControl) {
        let sortMode:YelpSortMode?
        
        switch(sender.selectedSegmentIndex) {
            case 1:
                sortMode = YelpSortMode.bestMatched
            case 2:
                sortMode = YelpSortMode.distance
            case 3:
                sortMode = YelpSortMode.highestRated
            default:
                sortMode = nil
        }
        
        // Set the sort filter according to selected option by user
        // Selecting "None" will make the sortMode nil
        if (sortMode == nil) {
            filter["sort"] = nil
            return
        }
        
        filter["sort"] = sortMode as AnyObject?
    }
    
    /**
     *  Action outlet for setting Category in "filter"
     *
     */
    @IBAction func setCategory(_ sender: UISwitch) {
        // **********************************************************
        // NOTE: Only 4 Categories added as requested in README.md  *
        // Didn't go for implementation of what Tim showed in video *
        // in favor of other items but will take care of it if found*
        // time.                                                    *
        // **********************************************************
        let categories = ["afghani", "african", "newamerican", "tradamerican"]
        var categoriesChosen = Set<String>()
        
        if sender.isOn {
            categoriesChosen.insert(categories[sender.tag])
        }
        else {
            categoriesChosen.remove(categories[sender.tag])
        }
        
        let categoriesArray = Array(categoriesChosen) as [String]
        
        filter["categories"] = categoriesArray as AnyObject?
    }

}
