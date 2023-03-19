//
//  NetworkError.swift
//
//
//  Created by Luis Gustavo on 11/01/23.
//
import Foundation

public enum NetworkError: Error, LocalizedError, CustomStringConvertible, Hashable {

    case dataMustExist
    case notHTTPURLResponse
    case queryParameters(URL, [String: Any])
    case unableToCreateURL
    case unknownStatusCode(Int)
    case unmapped(Error)

    public var description: String {
        switch self {
        case .dataMustExist: return "dataMustExist"
        case .notHTTPURLResponse: return "notHTTPUrlResponse"
        case .queryParameters: return "unableToCreateQueryParameters"
        case .unableToCreateURL: return "unableToCreateUrl"
        case .unknownStatusCode: return "unknownStatusCode"
        case let .unmapped(error): return error.localizedDescription
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(localizedDescription)
    }
}
