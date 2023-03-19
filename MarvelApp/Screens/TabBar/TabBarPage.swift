//
//  TabBarPage.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

enum TabBarPage: CaseIterable {
    case comics, cart, favorite

    var title: String {
        switch self {
        case .comics:
            return Localizable.comics.localized
        case .cart:
            return Localizable.cart.localized
        case .favorite:
            return Localizable.favorites.localized
        }
    }

    var image: UIImage? {
        switch self {
        case .comics:
            return .init(systemName: "magazine")
        case .cart:
            return .init(systemName: "cart")
        case .favorite:
            return .init(systemName: "heart")
        }
    }

    var tag: Int {
        switch self {
        case .comics:
            return 1
        case .cart:
            return 2
        case .favorite:
            return 3
        }
    }
}
