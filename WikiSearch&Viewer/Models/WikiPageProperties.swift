//
//  WikiPageProperties.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation

typealias PageProperties = WikiPageProperties.Page

// Structure for the entire API Response from Wikipedia

struct WikiPageProperties: Codable {
    let query: Query
    
    struct Query: Codable {
        let pages: PageResults
    }

    struct Page: Codable {
        let title: String
        let touched: String
        let fullurl: String
    }
    
    struct PageResults: Codable {
        let properties: [Page]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let pagePropertiesDictionary: [String: Page] = try container.decode([String: Page].self)
            
            properties = pagePropertiesDictionary.values.map({$0})
        }
    }
}
