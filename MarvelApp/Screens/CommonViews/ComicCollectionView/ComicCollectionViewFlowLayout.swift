//
//  ComicCollectionViewFlowLayout.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

final class ComicCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Init
    override init() {
        super.init()
        scrollDirection = .vertical
        sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
