//
//  ViewCodable.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation

protocol ViewCodable {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupViewConfiguration()
}

extension ViewCodable {
    func setupViewConfiguration() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
