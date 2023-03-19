//
//  ResultsViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation

struct ResultsViewModel {

    // MARK: - Properties
    let noResultsType: NoResultsType

    // MARK: - Init
    init(noResultsType: NoResultsType) {
        self.noResultsType = noResultsType
    }
}
