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
    
    func HTTPRequest(endPoint: String, normalizedData: Bool = true,
                     completionHandler: @escaping CompletionsWithThrow<Any>) -> Void {
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
            completionHandler({ normalizedData ? self.normalizeData(cachedResponse.data) :
                cachedResponse.data })
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
            completionHandler({ normalizedData ? self.normalizeData(data) : data })
            
        }.resume()
    }
    
    // This API will transform the original response from the iTunes Search Web Service into
    // a normalize response and will return it as a Data object. This is a requirement that can
    // be performed on the native side
    func normalizeData(_ data: Data) -> Data {
        let normalizeKeys = ["trackId", "trackName", "artworkUrl100", "primaryGenreName",
                             "trackViewUrl"]
        var normalizeJSONDict = [String: [[String: Any]]]()
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let results = json["results"] as? [[String: Any]] {
            
            results.forEach { dict in
                if let mainKey = dict["kind"] as? String {
                    let auxDict = dict.filter({ normalizeKeys.contains($0.key) })
                    if normalizeJSONDict[mainKey] == nil {
                        normalizeJSONDict[mainKey] = [auxDict]
                    } else {
                        normalizeJSONDict[mainKey]?.append(auxDict)
                    }
                }
            }
        
            if let normalizeData: Data = try? JSONSerialization.data(withJSONObject:
                    normalizeJSONDict, options: .sortedKeys) {
                    return normalizeData
            }
        }
        
        return Data()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse,
    completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("Hola")
    }

    
}

