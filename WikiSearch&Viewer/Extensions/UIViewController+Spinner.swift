//
//  UIViewController+Spinner.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/21/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showPopupAlert(title: String, message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showActivityIndicatory(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .white) {
        let activityView = UIActivityIndicatorView(style: style)
        activityView.color = color
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        activityView.startAnimating()
    }
    
    func stopActivityIndicatory() {
        DispatchQueue.main.async {
            guard let activityIndicator: UIActivityIndicatorView = self.view.subviews.first(where:
                {$0.isKind(of: UIActivityIndicatorView.self)}) as? UIActivityIndicatorView else {
                    return
            }
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
