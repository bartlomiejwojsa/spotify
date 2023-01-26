//
//  Settings.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 06/11/2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
