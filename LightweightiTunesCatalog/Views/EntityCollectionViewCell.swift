//
//  EntityCollectionViewCell.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/23/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

struct EntityCellViewModel {
    let isFavorite: Bool
    let artworkUrl100: String?
    let name: String?
    let genre: String?
    let itunesLink: String?
}

class EntityCollectionViewCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
           
        return stackView
    }()
    
    let badgeView: UIView = {
        let badgeView = UIView()
        
        badgeView.layer.cornerRadius = 10
        badgeView.layer.borderColor = UIColor.lightGray.cgColor
        badgeView.layer.borderWidth = 1.5
        badgeView.backgroundColor = .white
        badgeView.clipsToBounds = true
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        return badgeView
    }()
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyImage")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = false
           
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(for: .body, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
    }()

    private let itunesLinkTextView: UITextView = {
        let textView = UITextView()
        textView.dataDetectorTypes = .link
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0.0
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.translatesAutoresizingMaskIntoConstraints = false
           
        return textView
    }()
    
    let iTunesSearchService = ItunesSearchService()
    static let cellReuseIdentifier = "EntityCell"
    static let darkRedColor = UIColor(red: 205/256, green: 0.0, blue: 0.0, alpha: 1.0)
    
    private func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(coverImage)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(itunesLinkTextView)
        stackView.addSubview(badgeView)
        
        badgeView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        badgeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        badgeView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -5).isActive = true
        badgeView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        badgeView.backgroundColor = .white
        coverImage.alpha = 0
        nameLabel.text = nil
        genreLabel.text = nil
        itunesLinkTextView.text = nil
    }
    
    func setupCellWithModel(_ viewModel: EntityCellViewModel) {
        // Sets the badge state
        badgeView.backgroundColor = viewModel.isFavorite ? EntityCollectionViewCell.darkRedColor : .white
        
        // Sets the media picture
        iTunesSearchService.fetchPicture(pictureURL:
        viewModel.artworkUrl100 ?? "") { [weak self] image in
            self?.coverImage.fadeIn(duration: 0.4)
            DispatchQueue.main.async {
                self?.coverImage.image = image
            }
        }
        
        // Sets name and genre
        nameLabel.text = viewModel.name
        genreLabel.text = viewModel.genre
        
        // Sets the link to iTunes
        if let url = URL(string: viewModel.itunesLink ?? "") {
            let linkText = NSMutableAttributedString(string: "See in iTunes",
                                                     attributes: [NSAttributedString.Key.link: url])
            itunesLinkTextView.attributedText = linkText
        }
    }
    
    func setFavoriteBadgeBackgroundColor() {
        badgeView.backgroundColor = badgeView.backgroundColor == EntityCollectionViewCell.darkRedColor ?
            .white : EntityCollectionViewCell.darkRedColor
    }
}
