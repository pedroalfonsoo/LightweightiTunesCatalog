//
//  WikiPageProperties.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

struct EntityKind: Decodable {
    let album: [Entity]?
    let artist: [Entity]?
    let book: [Entity]?
    let coachedAudio: [Entity]?
    let featureMovie: [Entity]?
    let interactiveBooklet: [Entity]?
    let musicVideo: [Entity]?
    let pdfPodcast: [Entity]?
    let podcastEpisode: [Entity]?
    let softwarePackage: [Entity]?
    let song: [Entity]?
    let tvEpisode: [Entity]?
    
    private enum CodingKeys: String, CodingKey {
        case album
        case artist
        case book
        case coachedAudio = "coached-audio"
        case featureMovie = "feature-movie"
        case interactiveBooklet = "interactive-booklet"
        case musicVideo = "music-video"
        case pdfPodcast = "pdf-podcast"
        case podcastEpisode = "podcast-episode"
        case softwarePackage = "software-package"
        case song
        case tvEpisode = "tv-episode"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        album = try? container.decode([Entity].self, forKey: .album)                                           
        artist = try? container.decode([Entity].self, forKey: .artist)
        book = try? container.decode([Entity].self, forKey: .book)
        coachedAudio = try? container.decode([Entity].self, forKey: .coachedAudio)
        featureMovie = try? container.decode([Entity].self, forKey: .featureMovie)
        interactiveBooklet = try? container.decode([Entity].self, forKey: .interactiveBooklet)
        musicVideo = try? container.decode([Entity].self, forKey: .musicVideo)
        pdfPodcast = try? container.decode([Entity].self, forKey: .pdfPodcast)
        podcastEpisode = try? container.decode([Entity].self, forKey: .podcastEpisode)
        softwarePackage = try? container.decode([Entity].self, forKey: .softwarePackage)
        song = try? container.decode([Entity].self, forKey: .song)
        tvEpisode = try? container.decode([Entity].self, forKey: .tvEpisode)
    }
}

struct Entity: Decodable, Equatable {
    let trackId: UInt64
    let trackName: String
    let artworkUrl100: String
    let primaryGenreName: String
    let trackViewUrl: String
}
