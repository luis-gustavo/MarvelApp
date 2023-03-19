//
//  StorageError.swift
//  Storage
//
//  Created by Luis Gustavo on 18/03/23.
//

import Foundation

public enum StorageError: Error, CustomStringConvertible {
    case connectionCreation(Error)
    case tableCreation(Error)
    case insertion(Error)
    case selection(Error)
    case unknown(Error)

    public var description: String {
        switch self {
        case .connectionCreation(let error):
            return Localizable.connectionCreationError(error).localized
        case .tableCreation(let error):
            return Localizable.tableCreationError(error).localized
        case .insertion(let error):
            return Localizable.insertionError(error).localized
        case .selection(let error):
            return Localizable.selectionError(error).localized
        case .unknown(let error):
            return Localizable.unknownError(error).localized
        }
    }
}
