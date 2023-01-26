//
//  PlaylistDetailsResponse.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 22/11/2022.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    // if some parameter is a keyword we can surround it with `` to escape that keyword
//    let `public`: Bool
    let tracks: PlaylistDtTracksResponse
}

struct PlaylistDtTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
