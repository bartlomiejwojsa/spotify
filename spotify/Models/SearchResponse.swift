//
//  SearchResponse.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 05/02/2023.
//

import Foundation


struct SearchResponse: Codable {
    let tracks: SearchTracksResponse
    let albums: SearchAlbumsResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}

struct SearchAlbumsResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}
