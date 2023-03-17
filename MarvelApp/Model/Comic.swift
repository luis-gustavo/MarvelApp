//
//  Comic.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

struct Comic: Codable, Hashable {

    // MARK: - Properties
    let id: Int
    let title: String
    let thumbnail: Image

    // MARK: - Hashable
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(thumbnail.url)
    }
}
