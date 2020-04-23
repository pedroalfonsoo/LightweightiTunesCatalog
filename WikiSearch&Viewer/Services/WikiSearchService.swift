//
//  WikiSearchService.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation
import UIKit

class WikiSearchService {
    private let transport = HttpTransport()
    private let endPointForWikiSearch = "https://en.wikipedia.org/w/api.php?action=query&generator=search&format=json&continue=gsroffset%7C%7C&prop=info&inprop=url&gsrsort=relevance"
    
    func fetchResults(_ searchCriteria: String, offset: Int, resultsLimit: Int, completionHandler: @escaping CompletionsWithThrow<Any>) -> Void {
        
        // To form the finalURL
        let offsetString = "&gsroffset=\(offset)"
        let resultsLimit = "&gsrlimit=\(resultsLimit)"
        let searchCriteriaWithEncodedSpacing = "&gsrsearch=" + searchCriteria.replacingOccurrences(of: " ", with: "%20")
        let finalURL = endPointForWikiSearch + offsetString + resultsLimit + searchCriteriaWithEncodedSpacing
        
        transport.HTTPRequest(endPoint: finalURL) { result in
            do {
                if let response = try result() as? Data {
                    let pages = try JSONDecoder().decode(WikiPageProperties.self, from: response)
                    print(pages)
                    completionHandler({ pages })
                }
            } catch let e {
                completionHandler({ throw e })
            }
        }
    }
}
