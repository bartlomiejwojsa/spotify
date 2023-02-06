//
//  SearchResults.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 06/02/2023.
//

import Foundation

enum SearchResult {
    case track(model: AudioTrack)
    case album(model: Album)
    case artist(model: Artist)
    case playlist(model: Playlist)
}
