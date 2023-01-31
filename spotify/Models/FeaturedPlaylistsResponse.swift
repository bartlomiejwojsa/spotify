//
//  FeaturedPlaylists.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 15/11/2022.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}
