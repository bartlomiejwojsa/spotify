//
//  ARtist.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import Foundation

struct Artist: Codable {
    internal init(id: String, name: String, type: String, external_urls: [String : String]) {
        self.id = id
        self.name = name
        self.type = type
        self.external_urls = external_urls
    }
    
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
