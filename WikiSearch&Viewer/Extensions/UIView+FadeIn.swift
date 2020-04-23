//
//  UIView+FadeIn.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/21/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func fadeIn(duration durationTime: TimeInterval = 0.5, delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        alpha  = 0
        UIView.animate(withDuration: durationTime, delay: delay, options: .curveLinear, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
}
