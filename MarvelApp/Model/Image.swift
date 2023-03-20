//
//  Image.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

struct Image: Codable {

    // MARK: - Properties
    var url: URL? { URL(string: "\(path).\(`extension`)") }
    private let path: String
    private let `extension`: String

    init(path: String, extension: String) {
        self.path = path
        self.`extension` = `extension`
    }
}
