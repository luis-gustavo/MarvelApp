//
//  Price.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

struct Price: Codable {

    // MARK: - Type
    private enum `Type`: String {
        case printPrice, digitalPurchasePrice

        var title: String {
            switch self {
            case .printPrice:
                return Localizable.price.localized
            case .digitalPurchasePrice:
                return Localizable.digitalPrice.localized
            }
        }
    }

    // MARK: - Properties
    var typeTitle: String {
        (`Type`(rawValue: type) ?? .printPrice).title
    }
    let price: Float
    private let type: String
}
