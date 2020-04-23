//
//  HttpTransport.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation

typealias CompletionsWithThrow<T> = (() throws -> T) -> Void

enum NetworkError: Error {
    case invalidURL
    case networkRequestFailed
    case invalidData
    case serverResponseError
    case invalidJSONResponse
    case jSONSerializingError
}

struct NetWorkLayerError: Error {
    let networkError: NetworkError
    let error: Error?
    
    init(_ networkError: NetworkError, _ error: Error?) {
        self.networkError = networkError
        self.error = error
    }
}

class HttpTransport {
    private var session: URLSession?
    private let sessionTimeOutInterval: Int = 130
    
    init() {
        setSessionConfiguration()
    }
    
    private func setSessionConfiguration() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(3)
        configuration.timeoutIntervalForResource = TimeInterval(300)
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }
    
    func HTTPRequest(endPoint: String, completionHandler: @escaping CompletionsWithThrow<Any>) -> Void {
        // Checks if the endpoint can be converted to a URL
        guard let url = URL(string: endPoint) else {
            completionHandler({ throw NetWorkLayerError(.invalidURL, nil) })
            return
        }
        
        // Creating 'URLRequest' object
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = TimeInterval(sessionTimeOutInterval)
        
        // Returns a cached Data object response, if the requested URL is already in disk
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            completionHandler({ cachedResponse.data })
            return
        }
        
        // URL is valid, 'dataTask' api can be called
        session?.dataTask(with: urlRequest) { (data, response, error) in
            // Checks for a connection error
            guard error == nil else {
                completionHandler({ throw NetWorkLayerError(.networkRequestFailed, error) })
                return
            }
            
            // Checks for invalid data
            guard let data = data else {
                completionHandler({ throw NetWorkLayerError(.serverResponseError, error) })
                return
            }
            
            // Checks for a successful response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                completionHandler({ throw NetWorkLayerError(.serverResponseError, error) })
                return
            }

            // Returning Data
            completionHandler({ data })
            
        }.resume()
    }
}

