//
//  CharacterEndpoint.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation
import Networking

// MARK: - Constants
private enum InfoPlistKey: String {
    case baseUrl = "BASE_URL"
    case privateKey = "PRIVATE_KEY"
    case publicKey = "PUBLIC_KEY"
}

// MARK: - Constants
private struct Constants {
    static func baseUrl() -> URL {
        guard let path = Bundle.main.object(forInfoDictionaryKey: InfoPlistKey.baseUrl.rawValue) as? String else {
            fatalError("The API base URL is not a string.")
        }
        guard let url = URL(string: path) else {
            fatalError("The API base URL is not valid.")
        }
        return url
    }

    static func privateKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: InfoPlistKey.privateKey.rawValue) as? String else {
            fatalError("Private Key not found on bundle")
        }
        return apiKey
    }

    static func publicKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: InfoPlistKey.publicKey.rawValue) as? String else {
            fatalError("Private Key not found on bundle")
        }
        return apiKey
    }
}

struct ComicQueryParameters {
    let offset: Int
    let limit: Int
    let text: String?
    let year: Int?

    init(offset: Int, limit: Int, text: String? = nil, year: Int? = nil) {
        self.offset = offset
        self.limit = limit
        self.text = text
        self.year = year
    }
}

enum ComicEndpoint: EndPoint {

    case comic(id: Int)
    case comics(queryParameters: ComicQueryParameters)

    var url: URL? {
        switch self {
        case .comics:
            return URL(string: "\(Constants.baseUrl())/comics")
        case let .comic(id):
            return URL(string: "\(Constants.baseUrl())/comics/\(id)")
        }
    }

    var method: HTTPMethod {
        switch self {
        case .comic, .comics:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .comic, .comics:
            return [:]
        }
    }

    var queryParameters: [String: Any] {
        let timestamp = "\(Int64(Date().timeIntervalSince1970 * 1000))"
        let hash = md5("\(timestamp)\(Constants.privateKey())\(Constants.publicKey())")
        let apiKey = Constants.publicKey()
        var parameters = [
            "ts": timestamp,
            "apikey": apiKey,
            "hash": hash
        ]

        switch self {
        case let .comics(queryParameters):
            parameters["limit"] = "\(queryParameters.limit)"
            parameters["offset"] = "\(queryParameters.offset)"
            if let text = queryParameters.text,
               !text.isEmpty {
                parameters["titleStartsWith"] = text
            }
            if let year = queryParameters.year {
                parameters["startYear"] = "\(year)"
            }
            return parameters
        case .comic:
            return parameters
        }
    }

    var body: Data? {
        switch self {
        case .comic, .comics:
            return nil
        }
    }
}
