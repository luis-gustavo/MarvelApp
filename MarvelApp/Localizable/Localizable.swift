//
//  Localizable.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation

enum Localizable {

    case buy,
         cart,
         checkout,
         checkoutMessage,
         comics,
         digitalPrice,
         email,
         favorites,
         issue,
         login,
         okMessage,
         password,
         price,
         removeFilter,
         search

    var localized: String {
        switch self {
        case .buy:
            return "BUY".localize()
        case .cart:
            return "CART".localize()
        case .checkout:
            return "CHECKOUT".localize()
        case .checkoutMessage:
            return "CHECKOUT_MESSAGE".localize()
        case .comics:
            return "COMICS".localize()
        case .digitalPrice:
            return "DIGITAL_PRICE".localize()
        case .email:
            return "EMAIL".localize()
        case .favorites:
            return "FAVORITES".localize()
        case .issue:
            return "ISSUE".localize()
        case .login:
            return "LOGIN".localize()
        case .okMessage:
            return "OK".localize()
        case .password:
            return "PASSWORD".localize()
        case .price:
            return "PRICE".localize()
        case .removeFilter:
            return "REMOVE_FILTER".localize()
        case .search:
            return "SEARCH".localize()
        }
    }
}

// MARK: - Localize
fileprivate extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func localize(with arguments: [CVarArg]) -> String {
        return String(format: self.localize(), arguments: arguments)
    }
}
