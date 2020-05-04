//
//  SegmentedControl.swift
//  LightweightiTunesCatalog
//
//  Created by Pedro Alfonso on 5/1/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate: class {
    func segmentDidChange()
}

enum SegmentType: Int {
    case favorites
    case results
}

class SegmentedControl: UISegmentedControl {
    private(set) var currentSegment: SegmentType = .results
    
    weak var delegate: SegmentedControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        insertSegment(withTitle: "Favorites", at: SegmentType.favorites.rawValue, animated: false)
        insertSegment(withTitle: "Results", at: SegmentType.results.rawValue, animated: false)
        selectedSegmentIndex = currentSegment.rawValue
        setTitleTextAttributes([.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.preferredFont(for: .callout, weight: .regular)], for: .normal)
        addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segmentChanged() {
        currentSegment = SegmentType(rawValue: selectedSegmentIndex) ?? SegmentType.results
        delegate?.segmentDidChange()
    }
}
