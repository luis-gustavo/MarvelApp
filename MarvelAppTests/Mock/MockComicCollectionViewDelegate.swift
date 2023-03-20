//
//  MockComicCollectionViewDelegate.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
@testable import MarvelApp

final class MockComicCollectionViewDelegate: ComicCollectionViewDataSourceProtocol {

    func didSelectComic(at index: Int) { }

    func shouldFetchMoreData() { }

    func showLoadMore() -> Bool { false }

    func isLoadingMore() -> Bool { false }

    func cellViewModels() -> [ComicCollectionViewCellViewModel] {
        return [
            .init(
                title: "Iron Man",
                id: 0,
                imageUrl: Bundle(for: ImageLoaderTests.self).url(forResource: "logo", withExtension: "png")
            ),
            .init(
                title: "Captain America",
                id: 0,
                imageUrl: Bundle(for: ImageLoaderTests.self).url(forResource: "logo", withExtension: "png")
            )
        ]
    }
}
