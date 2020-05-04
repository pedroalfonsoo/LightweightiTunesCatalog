//
//  UICollectionView+ReloadWithAnimation.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/23/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func reloadDataWithAnimation(duration: Double = 0.3) {
        DispatchQueue.main.async {
            UIView.transition(with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: { self.reloadData() })
        }
    }
}
