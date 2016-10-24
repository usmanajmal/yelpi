//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, FiltersTableViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var searchSettings = YelpSearchSettings()
    var isMoreDataLoading = false
    var offset = 0
    
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
        
        tableView.delegate = self
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
    
    
    /**
     *  Call Search API for finding the business
     *  This function also updates the value of offset for retrieval
     *  of next set of data on infinite-scrolling
     */
    fileprivate func doSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let term = sanitizeString(str: searchSettings.searchString! as String)
        
        Business.searchWithTerm(term: term, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            
            print("BusinessCount: \(businesses?.count)")
            
            MBProgressHUD.hide(for: self.view, animated: false)
            
            // Update flag
            self.isMoreDataLoading = false
    
            // Update the offset for next call
            self.offset = self.offset + 20
    
            self.tableView.reloadData()
            }
        )
    }
    
    /**
     *  Searching based on filters set in Filters View
     */
    func filtersTableViewController(filtersTableViewController: FiltersTableViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let offeringDeals = filters["offeringDeals"] as? Bool
        let sortMode = filters["sort"] as? YelpSortMode
        let categories = filters["categories"] as? [String]
        let distance = filters["distance"] as? Int
        let offset = filters["offset"] as? Int
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.searchWithTerm(term: searchSettings.searchString!, sort: sortMode, categories: categories, deals: offeringDeals, distance: distance, offset: offset) { (businesses:[Business]?, error: Error?) -> Void in
            self.businesses = businesses

            MBProgressHUD.hide(for: self.view, animated: false)
            self.tableView.reloadData()
        }
    }
    
    /**
     *  Protocol for UIScrollView which gets called on each scroll
     *  Infinite scroll is implemented using this function
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                // print("scrolling")
                doSearch()
            }
        }
    }
    
    /**
     *  Helper function to avoid "nil" in search as that was found to
     *  to crash the app as well as searching using a term with only spaces
     *  like "   " doesn't return anything. So this function replaces a
     *  term with only spaces to ""
     *  @param {string} str String to be parsed
     *  @return Return modified or non-modified string
     */
    func sanitizeString(str: String) -> String {
        let newString: String = str.replacingOccurrences(of: " ", with: "")
        
        if (newString == "" || newString == "nil") {
            return ""
        }
        return str
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! UINavigationController
        let filtersTableViewController = destinationNavigationController.topViewController as! FiltersTableViewController
        
        filtersTableViewController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        doSearch()
    }
}
