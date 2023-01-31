//
//  Categories.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 30/01/2023.
//

import Foundation

struct BrowseCategoriesResponse: Codable {
    let categories: CategoriesResponse
}

struct CategoriesResponse: Codable {
    let items: [BrowseCategory]
}

struct BrowseCategory: Codable {
    let href: URL
    let icons: [APIImage]
    let id: String
    let name: String
}
