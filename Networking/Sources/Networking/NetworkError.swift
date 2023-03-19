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
        case .dataMustExist:
            return Localizable.dataMustExist.localized
        case .notHTTPURLResponse:
            return Localizable.notHttpUrlResponse.localized
        case .queryParameters:
            return Localizable.unableToCreateQueryParameters.localized
        case .unableToCreateURL:
            return Localizable.unableToCreateUrl.localized
        case .unknownStatusCode:
            return Localizable.unknownStatusCode.localized
        case let .unmapped(error):
            return error.localizedDescription
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(localizedDescription)
    }
}
