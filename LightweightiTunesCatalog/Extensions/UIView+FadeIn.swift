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
        DispatchQueue.main.async {
            self.alpha  = 0
            UIView.animate(withDuration: durationTime, delay: delay, options: .curveLinear, animations: {
                self.alpha = 1.0
            }, completion: completion)
        }
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
}
