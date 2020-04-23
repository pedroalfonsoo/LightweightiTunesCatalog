//
//  SearchResultsViewModel.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation

class SearchResultsViewModel {
    let offset = 50
    let limitOffset = 3000
    var searchText: String = ""
    private(set) var resultsOffset = 0
    private(set) var searchResults: [PageProperties]?
    private let dateTitleText = "This page was last edited on"
    
    init(searchText: String, searchResults: [PageProperties]?) {
        self.searchText = searchText
        self.searchResults = searchResults
        
        self.searchResults?.sort(by: { $0.title < $1.title })
    }
    
    func getCellViewModelForRow(_ rowIndex: Int) -> ResultCellViewModel? {
        guard let pages =  searchResults, pages.indices.contains(rowIndex) else {
            print("The row index: \(rowIndex), is not valid.")
            return nil
        }
        
        return ResultCellViewModel(pageTitle: pages[rowIndex].title,
                                   lastEdited: "\(dateTitleText) \(pages[rowIndex].touched.toUSDateFormat() ?? "")")
    }
    
    func setSearchToInitialState(searchText: String) {
        self.searchText = searchText
        resultsOffset = 0
    }
    
    func incrementOffset() {
        resultsOffset += offset
    }
    
    func updateSearchResultsWithOffset(offsetResults: [PageProperties]?) {
        guard let offsetResults = offsetResults else { return }
        
        searchResults?.append(contentsOf: offsetResults)
    }
}
