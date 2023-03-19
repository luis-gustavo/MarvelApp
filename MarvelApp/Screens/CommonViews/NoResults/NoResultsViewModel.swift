//
//  NoResultsViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

struct NoResultsViewModel {

    // MARK: - Properties
    private let `type`: NoResultsType
    var title: String { type.title }
    var image: UIImage? { type.image }

    // MARK: - Init
    init(type: NoResultsType) {
        self.type = type
    }
}
