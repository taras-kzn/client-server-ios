//
//  SearchViewController.swift
//  Weather
//
//  Created by admin on 23/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SearchViewController: UISearchController {
    
    private var filterArray = [PersonGroup]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpety : Bool{
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isFilterFriend : Bool {
        return searchController.isActive && !searchBarIsEmpety
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "searh"
        navigationItem.searchController = searchController
        definesPresentationContext = true

       
    }
    

    
}
