//
//  LaunchViewController.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit
import Foundation

class LaunchScreenViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "LaunchScreen")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
       return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SignPainter", size: 50.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.text = "Wiki Search & Viewer"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let splitViewController_ = SplitViewController(nibName: nil, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Will push the view controller that takes care of the search feature
        let mainViewController = SearchResultsTableViewController(wikiSearchService:
        WikiSearchService())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.pushViewController(mainViewController, animated: true)
            self.splitViewController_.setupWithViewControllers(masterVC: mainViewController,
                                                          detailVC: WebContentViewController(urlToLoad: ""))
            // Root view controller of window
            self.view.window?.rootViewController = self.splitViewController_
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
       
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
        imageView.fadeIn(duration: 0.7)
    }
}
