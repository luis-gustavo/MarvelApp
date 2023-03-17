//
//  CharacterEndpoint.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation
import Networking

// MARK: - Constants
private struct Constants {
    static let baseUrl = "https://gateway.marvel.com/v1/public"
    static let privateKey = "cc1622fb0b94fe7629778916edd8028494eaa131"
    static let publicKey = "c4a764b0b192ca33d2de5536a2258caf"
}

enum ComicEndpoint: EndPoint {

    case comics(offset: Int, limit: Int)

    var url: URL? {
        switch self {
        case .comics:
            return URL(string: "\(Constants.baseUrl)/comics")
        }
    }

    var method: HTTPMethod {
        switch self {
        case .comics:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .comics:
            return [:]
        }
    }

    var queryParameters: [String: Any] {
        let timestamp = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        let hash = md5("\(timestamp)\(Constants.privateKey)\(Constants.publicKey)")
        let apiKey = Constants.publicKey
        var parameters = [
            "ts": timestamp,
            "apikey": apiKey,
            "hash": hash
        ]

        switch self {
        case let .comics(offset, limit):
            parameters["limit"] = "\(limit)"
            parameters["offset"] = "\(offset)"
            return parameters
        }
    }

    var body: Data? {
        switch self {
        case .comics:
            return nil
        }
    }
}
