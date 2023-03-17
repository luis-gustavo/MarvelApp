//
//  ComicResponse.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

struct ComicResponse: Codable {

    // MARK: - Properties
    let data: ComicData
}

struct ComicData: Codable {

    // MARK: - Properties
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Comic]
}
