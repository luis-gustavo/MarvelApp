//
//  File.swift
//  
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation

enum Localizable {

    case serviceCantBeDowncasted(String, String),
         serviceWasntPreviouslyRegistered(String)

    var localized: String {
        switch self {
        case let .serviceCantBeDowncasted(service, type):
            return "SERVICE_CANT_BE_DOWNCASTED".localize(with: [service, type])
        case let .serviceWasntPreviouslyRegistered(service):
            return "SERVICE_WASNT_PREVIOUSLY_REGISTERED".localize(with: [service])
        }
    }
}

// MARK: - Localize
fileprivate extension String {
    func localize() -> String {
        return NSLocalizedString(self, bundle: .module, comment: "")
    }

    func localize(with arguments: [CVarArg]) -> String {
        return String(format: self.localize(), arguments: arguments)
    }
}
