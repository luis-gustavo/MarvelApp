//
//  TabBarPage.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

enum TabBarPage: CaseIterable {
    case comics

    var title: String {
        switch self {
        case .comics:
            return "Comics"
        }
    }

    var image: UIImage? {
        switch self {
        case .comics:
            return .init(systemName: "magazine")
        }
    }
}
