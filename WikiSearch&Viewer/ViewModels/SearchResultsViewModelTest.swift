//
//  SearchResultsViewModelTest.swift
//  WikiSearch&ViewerTests
//
//  Created by Pedro Alfonso on 4/23/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import XCTest
@testable import WikiSearch_Viewer

class SearchResultsViewModelTest: XCTestCase {

    var sut: SearchResultsViewModel?
    var response: WikiAPIResponse?
    var expectedResponse: [PageProperties]?
       
    override func setUp() {
        super.setUp()
        
        response = WikiAPIResponse()
        expectedResponse = response?.expectedResponse
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response?.responseData as Any,
                                                      options: .fragmentsAllowed)
            
            let pages = try JSONDecoder().decode(WikiPageProperties.self, from: jsonData as Data)
            let searchResult: WikiPageProperties = pages
            
            sut = SearchResultsViewModel(searchText: "Car", searchResults: searchResult.query.pages.properties)
        } catch {
            print("Error during data conversion.")
        }
    }
       
    func test_getCellViewModelForRow() {
        var cellViewModel = sut?.getCellViewModelForRow(0)
        XCTAssertEqual(cellViewModel?.pageTitle, expectedResponse?[0].title)
        
        cellViewModel = sut?.getCellViewModelForRow(1)
        XCTAssertEqual(cellViewModel?.pageTitle, expectedResponse?[1].title)
        
        cellViewModel = sut?.getCellViewModelForRow(2)
        XCTAssertEqual(cellViewModel?.pageTitle, expectedResponse?[2].title)
    }
    
    func test_setSearchToInitialState() {
        sut?.setSearchToInitialState(searchText: "Car")
        
        XCTAssertEqual(sut?.searchText, "Car")
        XCTAssertEqual(sut?.resultsOffset, 0)
    }
    
    func test_setSearchResults() {
        sut?.setAndSortSearchResults(searchResults: response?.extraResult ?? [])
        XCTAssertEqual(sut?.searchResults, response?.extraResult)
    }
    
    func test_incrementOffset() {
        sut?.incrementOffset()
        XCTAssertEqual(sut?.resultsOffset, sut?.offset)
    }
    
    func test_updateSearchResultsWithOffset() {
        let numberOfResult = sut?.searchResults?.count
        let numberOfNewResults = response?.extraResult.count ?? 0
        
        sut?.updateSearchResultsWithOffset(offsetResults: response?.extraResult)
        XCTAssertEqual(numberOfResult, numberOfResult ?? 0 + numberOfNewResults)
    }
}


class WikiAPIResponse
{
    var responseData: [String : Any]? {
    return ["batchcomplete": "",
            "continue": [
                "gsroffset": 50,
                "continue": "gsroffset||"
            ],
            "query": [
                "pages": [
                    "415724": [
                        "pageid": 415724,
                        "ns": 0,
                        "title": "Antique car",
                        "index": 33,
                        "contentmodel": "wikitext",
                        "pagelanguage": "en",
                        "pagelanguagehtmlcode": "en",
                        "pagelanguagedir": "ltr",
                        "touched": "2020-04-18T18:24:55Z",
                        "lastrevid": 945646245,
                        "length": 8542,
                        "fullurl": "https://en.wikipedia.org/wiki/Antique_car",
                        "editurl": "https://en.wikipedia.org/w/index.php?title=Antique_car&action=edit",
                        "canonicalurl": "https://en.wikipedia.org/wiki/Antique_car"
                    ],
                    "16267037": [
                        "pageid": 16267037,
                        "ns": 0,
                        "title": "Armored car",
                        "index": 21,
                        "contentmodel": "wikitext",
                        "pagelanguage": "en",
                        "pagelanguagehtmlcode": "en",
                        "pagelanguagedir": "ltr",
                        "touched": "2020-04-18T09:57:14Z",
                        "lastrevid": 889011904,
                        "length": 704,
                        "fullurl": "https://en.wikipedia.org/wiki/Armored_car",
                        "editurl": "https://en.wikipedia.org/w/index.php?title=Armored_car&action=edit",
                        "canonicalurl": "https://en.wikipedia.org/wiki/Armored_car"
                    ],
                    "535562": [
                        "pageid": 535562,
                        "ns": 0,
                        "title": "Bumper (car)",
                        "index": 26,
                        "contentmodel": "wikitext",
                        "pagelanguage": "en",
                        "pagelanguagehtmlcode": "en",
                        "pagelanguagedir": "ltr",
                        "touched": "2020-04-23T10:34:49Z",
                        "lastrevid": 944281738,
                        "length": 39993,
                        "fullurl": "https://en.wikipedia.org/wiki/Bumper_(car)",
                        "editurl": "https://en.wikipedia.org/w/index.php?title=Bumper_(car)&action=edit",
                        "canonicalurl": "https://en.wikipedia.org/wiki/Bumper_(car)"
                    ]
                ]
            ]
    ]
}
    
    let expectedResponse: [PageProperties] = {
        var pagePropertiesArray = [PageProperties]()
        
        pagePropertiesArray.append(PageProperties(title: "Antique car",
                                                  touched: "2020-04-18T18:24:55Z",
                                                  fullurl: "https://en.wikipedia.org/wiki/Antique_car"))
        
        pagePropertiesArray.append(PageProperties(title: "Armored car",
                                                  touched: "2020-04-18T09:57:14Z",
                                                  fullurl: "https://en.wikipedia.org/wiki/Antique_car"))
            
        pagePropertiesArray.append(PageProperties(title: "Bumper (car)",
                                                  touched: "2020-04-23T10:34:49Z",
                                                  fullurl: "https://en.wikipedia.org/wiki/Bumper_(car)"))
        
        return pagePropertiesArray
    }()
    
    let extraResult: [PageProperties] = {
        var pagePropertiesArray = [PageProperties]()
        
        pagePropertiesArray.append(PageProperties(title: "Extra Result",
                              touched: "2019-04-18T18:24:55Z",
                              fullurl: "https://en.wikipedia.org/wiki/Extra_Result"))
        
        return pagePropertiesArray
    }()
}
