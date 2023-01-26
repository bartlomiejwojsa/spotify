//
//  ARtist.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
