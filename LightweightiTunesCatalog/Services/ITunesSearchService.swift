//
//  ITunesSearchService.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

typealias CompletionNSImageWithThrow<NSImage> = (() throws -> UIImage) -> Void

class ItunesSearchService {
    private let transport: HttpTransport
    private let itunesSearchBaseEndPoint: String
    private(set) var urlRequestString: String
    
    init() {
        transport = HttpTransport()
        itunesSearchBaseEndPoint = "https://itunes.apple.com/search?term="
        urlRequestString = ""
    }
    
    func fetchResults(_ searchCriteria: String,
                      completionHandler: @escaping CompletionsWithThrow<Any>) -> Void {
        let searchCriteriaWithoutSpaces = searchCriteria.replacingOccurrences(of: " ", with: "+")
        urlRequestString = itunesSearchBaseEndPoint + searchCriteriaWithoutSpaces
        
        transport.HTTPRequest(endPoint: urlRequestString) { result in
            do {
                if let response = try result() as? Data {
                    let entities = try JSONDecoder().decode(EntityKind.self, from: response)
                    print(entities)
                    completionHandler({ entities })
                }
            } catch let e {
                completionHandler({ throw e })
            }
        }
    }
    
    func fetchPicture(pictureURL: String, completionHandler: @escaping (UIImage?) -> Void) {
         transport.HTTPRequest(endPoint: pictureURL ,normalizedData: false) { result in
         
            do {
                guard let responseData = try result() as? Data,
                    let image = UIImage(data: responseData) else {
                        return
                }
                
                completionHandler(image)
            } catch {
                completionHandler(nil)
            }
        }
    }
}
