//
//  SearchCollectionViewController.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
           
        return collectionView
    }()
    
    private let segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search on iTunes..."
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
           
        return searchBar
    }()
    
    private lazy var headerViewSupplementaryItem: NSCollectionLayoutBoundarySupplementaryItem = {
        let headerViewItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70)),
            elementKind: SearchCollectionViewController.headerElementKind,
            alignment: .top)

        return headerViewItem
    }()
    
    // MARK: Properties
    private let itunesSearchService: ItunesSearchService
    private var viewModel: SearchResultsViewModel
    static let headerElementKind = "header-element-kind"
    
    // MARK: Initializer
    init(itunesSearchService: ItunesSearchService) {
        viewModel = SearchResultsViewModel(searchText: "",
                                           searchResults: nil,
                                           urlRequestString: "")
        
        self.itunesSearchService = itunesSearchService
        
        super.init(nibName: nil, bundle: nil)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
           
        setupView()
    }
    
    private func setupView() {
        searchBar.delegate = self
        segmentedControl.delegate = self
        segmentedControl.setEnabled(!viewModel.favoritePersistedEntities.isEmpty,
                                    forSegmentAt: SegmentType.favorites.rawValue)
        navigationItem.titleView = searchBar

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationBarBackground"), for: .default)
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        setupSegmentedControllConstraints()
        setupCollectionView()
    }
    
    private func setupSegmentedControllConstraints() {
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: SearchCollectionViewController.headerElementKind,
                                withReuseIdentifier: HeaderView.reuseIdentifier)

        collectionView.register(EntityCollectionViewCell.self, forCellWithReuseIdentifier: EntityCollectionViewCell.cellReuseIdentifier)
        
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard self.viewModel.numberOfItemsInSection(section: sectionIndex) > 0 else {
                return nil
            }
            
            let item = NSCollectionLayoutItem(layoutSize:
                NSCollectionLayoutSize(widthDimension: .absolute(120),
                                       heightDimension: .fractionalHeight(1.0)))
            
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(10.0),
                                                             top: .fixed(0),
                                                             trailing: .fixed(10.0),
                                                             bottom: .fixed(0))
        
            let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.30),
                                       heightDimension: .estimated(240.0)),
                                                           subitem: item, count: 1)
            
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(10.0),
                                                              top: .fixed(0),
                                                              trailing: .fixed(10.0),
                                                              bottom: .fixed(0))
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = [self.headerViewSupplementaryItem]
            section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            return section
        }
        
        return layout
    }
    
    private func updateTableViewUI() {
        guard !(viewModel.searchResults.isEmpty) else {
            showPopupAlert(title: "Search", message: "There are no results for \"\(searchBar.text ?? "")\"")
            collectionView.bounces = false
            return
        }
        
        collectionView.isScrollEnabled = true
        collectionView.bounces = true
        collectionView.reloadDataWithAnimation(duration: 0.1)
    }
    
    private func fetchResults(completionHandler: (() -> ())? = nil) {
        showActivityIndicatory(style: .large, color: .black)
        
        itunesSearchService.fetchResults(viewModel.searchText) { [weak self] response in
            self?.stopActivityIndicatory()
            
            do {
                if let searchResults = try response() as? EntityKind {
                    self?.viewModel = SearchResultsViewModel(searchText: self?.viewModel.searchText ?? "",
                                                             searchResults: searchResults,
                                                             urlRequestString: self?.itunesSearchService.urlRequestString ?? "")
                    (completionHandler ?? {})()
                    DispatchQueue.main.async {
                        self?.updateTableViewUI()
                    }
                }
            } catch {
                self?.showPopupAlert(title: "Search Error", message: "Unable to retrieve result(s)")
            }
        }
    }
}


// MARK: - Collection view data source

extension SearchCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EntityCollectionViewCell.cellReuseIdentifier, for: indexPath) as? EntityCollectionViewCell,
            let cellViewModel = viewModel.getCellViewModelForRow(indexPath) else {
                return UICollectionViewCell()
        }
           
        cell.setupCellWithModel(cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.setupWithIndex(viewModel.numberOfItemsInSection(section: indexPath.section),
                                  indexPath: indexPath)
            
        return headerView
    }
}


// MARK: - Collection view delegates

extension SearchCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.currentSegment != .favorites {
            viewModel.updateFavorites(indexPath: indexPath)
            segmentedControl.setEnabled(!viewModel.favoritePersistedEntities.isEmpty, forSegmentAt:
                SegmentType.favorites.rawValue)
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? EntityCollectionViewCell else {
                return
            }
            
            cell.setFavoriteBadgeBackgroundColor()
        }
    }
}
    

// MARK: - Search bar Delegates
    
extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        viewModel.setSearchToInitialState(searchText: searchBarText)
        searchBar.resignFirstResponder()
        
        fetchResults() { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top,
                                                  animated: true)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if segmentedControl.currentSegment == .favorites {
            segmentedControl.selectedSegmentIndex = SegmentType.results.rawValue
            viewModel.shouldSetPersistentSelectedData(false)
            collectionView.reloadData()
        }
    }
}


// MARK: - Segmented Control delegates
    
extension SearchCollectionViewController: SegmentedControlDelegate {
    func segmentDidChange() {
        viewModel.shouldSetPersistentSelectedData(segmentedControl.currentSegment == .favorites)
        collectionView.reloadData()
    }
}


