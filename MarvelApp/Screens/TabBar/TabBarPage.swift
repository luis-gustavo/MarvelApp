//
//  TabBarPage.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

enum TabBarPage: CaseIterable {
    case characters

    var title: String {
        switch self {
        case .characters:
            return "Characters"
        }
    }
}
