//
//  SplitViewController.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/23/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit
import Foundation

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    func setupWithViewControllers(masterVC: UIViewController, detailVC: UIViewController) {
        delegate = self
        
        // Embed in navigation controllers
        let masterNavigationViewController = UINavigationController(rootViewController: masterVC)
        let detailNavigationController = UINavigationController(rootViewController: detailVC)
                      
        // Embed in Split View controller
        viewControllers = [masterNavigationViewController, detailNavigationController]
        
        let minimumWidth: CGFloat = min(view.bounds.width, view.bounds.height)
        minimumPrimaryColumnWidth = minimumWidth * 0.5
        maximumPrimaryColumnWidth = minimumWidth
        
        detailVC.navigationItem.leftItemsSupplementBackButton = true
        detailVC.navigationItem.leftBarButtonItem = displayModeButtonItem
        preferredDisplayMode = .primaryOverlay
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
