//
//  NoResultsType.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

enum NoResultsType {
    case search, cart, favorites

    var title: String {
        switch self {
        case .search:
            return "No Results"
        case .cart:
            return "Add items to cart"
        case .favorites:
            return "Add items to favorites"
        }
    }

    var image: UIImage? {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass.circle")
        case .cart:
            return UIImage(systemName: "cart.badge.plus")
        case .favorites:
            return UIImage(systemName: "heart.circle.fill")
        }
    }
}
