//
//  File.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

struct Playlist: Codable {
    let collaborative: Bool
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let tracks: PlaylistTracksResponse
    let type: String
    let uri: String
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
    let type: String
    let uri: String
}

struct PlaylistTracksResponse: Codable {
    let href: String
    let total: Int
}
