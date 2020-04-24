//
//  WorkoutSC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 20/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Foundation

public protocol SearchItem {
    func matchesSearchQuery(_ query: String) -> Bool
    func matchesScope(_ scopeName: String) -> Bool
}

extension SearchItem {
    func matchesScope(_ scopeName: String) -> Bool {
        return true
    }
}

extension String: SearchItem  {
    
    public func matchesSearchQuery(_ query: String) -> Bool {
        return self.lowercased().contains(query.lowercased())
    }
    
    public func matchesScope(_ value: String) -> Bool {
        return self == value
    }
}

extension WorkoutsVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    //    MARK: Search Controller's functionalities.
    
    func initiateFiltered () {
        UIView.setAnimationsEnabled(false)
        form.removeAll()
        for row in self.currentOptions {
            print(row.tag!)

            form +++ row
        }
        print("end")
        UIView.setAnimationsEnabled(true)
    }
    
    private func filterOptionsForSearchText(_ searchText: String, scope: String?) {
        if searchText.isEmpty {
            currentOptions = scope == nil ? originalOptions : originalOptions.filter { item in
                guard let value = item.value else { return false }
                return (scope == "All") || value.matchesScope(scope!)
            }
        } else if scope == nil {
            currentOptions = originalOptions.filter { $0.title?.matchesSearchQuery(searchText) ?? false}
        } else {
            currentOptions = originalOptions.filter { item in
                guard let value = item.value else { return false }
                
                let doesScopeMatch = (scope == "All") || value.matchesScope(scope!)
                return doesScopeMatch && item.title!.matchesSearchQuery(searchText)
            }
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text else { return }
        let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
        
        filterOptionsForSearchText(query, scope: scope)
        self.initiateFiltered()
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterOptionsForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles?[selectedScope])
        self.initiateFiltered()
    }
}
