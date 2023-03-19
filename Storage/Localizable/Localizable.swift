//
//  Localizable.swift
//  Storage
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation

enum Localizable {

    case connectionCreationError(Error),
         tableCreationError(Error),
         insertionError(Error),
         selectionError(Error),
         unknownError(Error)

    var localized: String {
        switch self {
        case let .connectionCreationError(error):
            return "CONNECTION_CREATION_ERROR".localize(with: [error.localizedDescription])

        case let .tableCreationError(error):
            return "TABLE_CREATION_ERROR".localize(with: [error.localizedDescription])

        case let .insertionError(error):
            return "INSERTION_ERROR".localize(with: [error.localizedDescription])

        case let .selectionError(error):
            return "SELECTION_ERROR".localize(with: [error.localizedDescription])

        case let .unknownError(error):
            return "UNKNOWN_ERROR".localize(with: [error.localizedDescription])
        }
    }
}

// MARK: - Localize
fileprivate extension String {
    func localize() -> String {
        return NSLocalizedString(
            self,
            bundle: Bundle(identifier: "com.luisgustavo.Storage") ?? Bundle.main,
            comment: ""
        )
    }

    func localize(with arguments: [CVarArg]) -> String {
        return String(format: self.localize(), arguments: arguments)
    }
}
