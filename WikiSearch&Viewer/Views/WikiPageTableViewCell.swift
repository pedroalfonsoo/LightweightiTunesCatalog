//
//  WikiPageTableViewCell.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/23/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

struct ResultCellViewModel {
    let pageTitle: String
    let lastEdited: String
}

class WikiPageTableViewCell: UITableViewCell {

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
           
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
    }()
    
    private let lastEditedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
    }()
    
    static let cellReuseIdentifier = "WikiPageTitleCell"
    
    private func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,
                                           constant: 12).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,
                                            constant: -30).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        lastEditedLabel.adjustsFontForContentSizeCategory = true
        lastEditedLabel.lineBreakMode = .byWordWrapping
        lastEditedLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(lastEditedLabel)
        addSubview(stackView)
               
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellWithModel(_ viewModel: ResultCellViewModel) {
        titleLabel.text = viewModel.pageTitle
        lastEditedLabel.text = viewModel.lastEdited
    }
}
