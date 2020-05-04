//
//  SearchResultsViewModel.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import Foundation

typealias FavoriteDictionary = [String: [Int: [UInt64]]]

enum FavoriteEntityKey: String {
    case requestURL
    case trackId
}

enum MediaTypes: Int, CaseIterable {
    case album
    case artist
    case book
    case coachedAudio
    case featureMovie
    case interactiveBooklet
    case musicVideo
    case pdfPodcast
    case podcastEpisode
    case softwarePackage
    case song
    case tvEpisode
    
    func getName() -> String {
        switch self {
         case .album:
            return "album"
        case .artist:
            return "artist"
        case .book:
            return "book"
        case .coachedAudio:
            return "coached-audio"
        case .featureMovie:
            return "feature-movie"
        case .interactiveBooklet:
            return "interactive-booklet"
        case .musicVideo:
            return "music-video"
        case .pdfPodcast:
            return "pdf-podcast"
        case .podcastEpisode:
            return "podcast-episode"
        case .softwarePackage:
            return "software-package"
        case .song:
            return "song"
        case .tvEpisode:
            return "tv-episode"
        }
    }
    
    func getSectionName() -> String {
        switch self {
         case .album:
            return "Albums"
        case .artist:
            return "Artists"
        case .book:
            return "Books"
        case .coachedAudio:
            return "Coached Audios"
        case .featureMovie:
            return "Feature Movies"
        case .interactiveBooklet:
            return "Interactive Booklets"
        case .musicVideo:
            return "Music Videos"
        case .pdfPodcast:
            return "Pdf Podcast"
        case .podcastEpisode:
            return "Podcast Episodes"
        case .softwarePackage:
            return "Software Packages"
        case .song:
            return "Songs"
        case .tvEpisode:
            return "TV Episodes"
        }
    }
}

struct SearchResultsViewModel {
    private(set) var searchText: String
    private(set) var favoritePersistedEntities: FavoriteDictionary
    private(set) var searchResults: [[Entity]?]
    private(set) var searchResultsTmp: [[Entity]?]
    let urlRequestString: String
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "favorites"
    private static let notSpecified = "Not specified"
    
    init(searchText: String, searchResults: EntityKind?, urlRequestString: String) {
        self.searchText = searchText
        
        if let data = userDefaults.data(forKey: userDefaultsKey), let favoriteEntities = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? FavoriteDictionary {
            self.favoritePersistedEntities = favoriteEntities
        } else {
            self.favoritePersistedEntities = [:]
        }

        self.urlRequestString = urlRequestString
        self.searchResults = SearchResultsViewModel.populateByKind(source: searchResults)
        self.searchResultsTmp = []
    }
    
    private static func populateByKind(source: EntityKind?) -> [[Entity]?] {
        var array = [[Entity]?]()
        
        guard let source = source else {
            return Array(repeating: [], count: MediaTypes.allCases.count)
        }
        
        array.append(source.album)
        array.append(source.artist)
        array.append(source.book)
        array.append(source.coachedAudio)
        array.append(source.featureMovie)
        array.append(source.interactiveBooklet)
        array.append(source.musicVideo)
        array.append(source.pdfPodcast)
        array.append(source.podcastEpisode)
        array.append(source.softwarePackage)
        array.append(source.song)
        array.append(source.tvEpisode)
        
        return array
    }
    
    func numberOfSections() -> Int {
        return searchResults.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard searchResults.indices.contains(section) else {
            return 0
        }
        
        return searchResults[section]?.count ?? 0
    }
    
    func getCellViewModelForRow(_ indexPath: IndexPath) -> EntityCellViewModel? {
        guard searchResults.indices.contains(indexPath.section),
            let _ = searchResults[indexPath.section]?.indices.contains(indexPath.row),
            let entity = searchResults[indexPath.section]?[indexPath.row] else {
            return nil
        }
        
        let favoritesValue = favoritePersistedEntities[urlRequestString]
        return EntityCellViewModel(isFavorite: favoritesValue?[indexPath.section]?.contains(entity.trackId) ?? false,
                                   artworkUrl100: entity.artworkUrl100,
                                   name:entity.trackName,
                                   genre: entity.primaryGenreName,
                                   itunesLink: entity.trackViewUrl)
    }
    
    mutating func setSearchToInitialState(searchText: String) {
        self.searchText = searchText
    }
    
    mutating func updateFavorites(indexPath: IndexPath) {
        if searchResults.indices.contains(indexPath.section), let _ =
            searchResults[indexPath.section]?.indices.contains(indexPath.row) {
            
            let trackId = searchResults[indexPath.section]?[indexPath.row].trackId
            
            // Creates the url on the dictionary if it doesn't exist
            if favoritePersistedEntities[urlRequestString] == nil {
                favoritePersistedEntities[urlRequestString] = [:]
            }
            
            var kindDictionary = favoritePersistedEntities[urlRequestString]
            
            if kindDictionary?[indexPath.section] == nil {
                kindDictionary?[indexPath.section] = []
            }
            
            // Adds or removes the 'trackId' depending on if it exists or not
            if let index = kindDictionary?[indexPath.section]?.firstIndex(where: { $0 == trackId }) {
                kindDictionary?[indexPath.section]?.remove(at: index)
            } else {
                kindDictionary?[indexPath.section]?.append(trackId ?? 0)
            }
            
            if kindDictionary?[indexPath.section]?.isEmpty ?? false {
                favoritePersistedEntities.removeValue(forKey: urlRequestString)
            } else {
                // Updates the value on the 'favoritePersistedEntities'dictionary
                favoritePersistedEntities[urlRequestString] = kindDictionary
            }
            
            // Any update should be persisted
            userDefaults.set(try? NSKeyedArchiver.archivedData(withRootObject: favoritePersistedEntities, requiringSecureCoding: false), forKey: userDefaultsKey)
        }
    }
    
    mutating func shouldSetPersistentSelectedData(_ shouldSet: Bool) {
        let httpTransport = HttpTransport()

        guard shouldSet else {
            searchResults = searchResultsTmp
            searchResultsTmp = []
            return
        }

        searchResultsTmp = searchResults
        for index in 0..<searchResults.count {
            searchResults[index] = []
        }
        
        // Iterates over the dictionary in order to update 'searchResults' property
        for key in favoritePersistedEntities.keys {
            if let url = URL(string: key),
                let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
                let entityKind = try? JSONDecoder().decode(EntityKind.self, from:
                    httpTransport.normalizeData(cachedResponse.data)) {
                
                var partialSearchResults = Self.populateByKind(source: entityKind)
                
                if let dictValue = favoritePersistedEntities[key] {
                    for index in 0..<partialSearchResults.count {
                        if !dictValue.keys.contains(index) {
                            partialSearchResults[index] = []
                        }
                    }
                    
                    for key in dictValue.keys {
                        partialSearchResults[key] = partialSearchResults[key]?.filter({ entity -> Bool in
                            return (dictValue[key]?.contains(entity.trackId) ?? false)
                        })
                    }
                
                // Add the partial search results to the original search results
                    for (index, entityArray) in partialSearchResults.enumerated() {
                        if !(entityArray?.isEmpty ?? true) {
                            searchResults[index]?.append(contentsOf: entityArray ?? [])
                        }
                    }
                }
            }
        }
    }
}
