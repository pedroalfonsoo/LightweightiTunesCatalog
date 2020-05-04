//
//  HeaderView.swift
//  LightweightiTunesCatalog
//
//  Created by Pedro Alfonso on 4/30/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "header-reuse-identifier"
    static let lightGrayColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1.0)

    let label: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(for: .title3, weight: .bold)
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        let inset: CGFloat = 10.0
    
        backgroundColor = .systemBackground
        addSubview(label)

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
    }
    
    func setupWithIndex(_ numberOfItems: Int, indexPath: IndexPath) {
        label.text = ("\(MediaTypes(rawValue: indexPath.section)?.getSectionName() ?? "") (\(numberOfItems))")
        addTopBorder(with: HeaderView.lightGrayColor, andWidth: 1)
    }
}
