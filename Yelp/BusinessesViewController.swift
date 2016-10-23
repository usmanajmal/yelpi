//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var searchSettings = YelpSearchSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Have autolayout
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        
        // Perform the first search when the view controller first loads
        doSearch()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businesses == nil {
            return 0
        }
        
        return businesses.count
    }
    
    // Perform the search.
    fileprivate func doSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.searchWithTerm(term: searchSettings.searchString! as String, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            
            // DEBUG
            /*if let businesses = businesses {
             for business in businesses {
             print("\(business.name!) [\(business.categories!)]")
             }
             }*/
            
            MBProgressHUD.hide(for: self.view, animated: false)
            self.tableView.reloadData()
            
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! UINavigationController
        let filtersTableViewController = destinationNavigationController.topViewController as! FiltersTableViewController
        
        filtersTableViewController.delegate = self
    }
    
    func filtersTableViewController(filtersTableViewController: FiltersTableViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let offeringDeals = filters["offeringDeals"] as? Bool
        let sortMode = filters["sort"] as? YelpSortMode
        print("BVC: OfferingDeals: \(offeringDeals!)")
        print("BVC: Sort: \(sortMode?.rawValue)")
        
        let categories = filters["categories"] as? [String]
        let distance = filters["distance"] as? Int
        
        Business.searchWithTerm(term: searchSettings.searchString!, sort: sortMode, categories: categories, deals: offeringDeals, distance: distance) { (businesses:[Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        print("Search buttong clicked")
        doSearch()
    }
}
