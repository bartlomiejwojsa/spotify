//
//  Responses.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 26/01/2023.
//

import Foundation

enum GroupResponse {
    case featuredPlaylists(FeaturedPlaylistsResponse)
    case newRealeses(NewReleasesResponse)
    case recommendations(RecommendationsResponse)
}
