//
//  ComicCollectionView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

final class ComicCollectionView: UICollectionView {

    // MARK: - Inits
    init() {
        super.init(frame: .zero, collectionViewLayout: ComicCollectionViewFlowLayout())
        allowsSelection = true
        allowsMultipleSelection = false
        register(
            ComicCollectionViewCell.self,
            forCellWithReuseIdentifier: ComicCollectionViewCell.identifier
        )
        register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
