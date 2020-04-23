//
//  String+DateFormatter.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/21/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation

extension String {
    func toUSDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
