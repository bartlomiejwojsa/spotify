//
//  RecommendationsResponse.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 15/11/2022.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
