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
    let NUMBER_OF_SECTIONS = 4
    
    let categories = ["afghani", "african", "newamerican", "tradamerican"]
    var categoriesChosen = Set<String>()
    
    @IBOutlet var distanceOutletCollection: [UISwitch]!
    @IBOutlet weak var offerringDealsSwitch: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.apportionsSegmentWidthsByContent = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete implementation, return the number of rows
        
        // print("Section: \(section)")
        
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

    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        print("Cancelling...")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnTapped(_ sender: AnyObject) {
        // Dismiss the modal
        dismiss(animated: true, completion: nil)
        
        // Set Offering Deals option
        
        filter["offeringDeals"] = offerringDealsSwitch.isOn as AnyObject
        
        
        delegate?.filtersTableViewController?(filtersTableViewController: self, didUpdateFilters: filter)
    }
    
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
        print(sortMode)
        
        // Selecting "None" will make the sortMode nil
        if (sortMode == nil) {
            filter["sort"] = nil
            return
        }
        
        filter["sort"] = sortMode as AnyObject?
    }
    
    
    @IBAction func setCategory(_ sender: UISwitch) {
        
        if sender.isOn {
            categoriesChosen.insert(categories[sender.tag])
        }
        else {
            categoriesChosen.remove(categories[sender.tag])
        }
        
        let categoriesArray = Array(categoriesChosen) as [String]
        // print(categoriesArray)
        
        filter["categories"] = categoriesArray as AnyObject?
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
