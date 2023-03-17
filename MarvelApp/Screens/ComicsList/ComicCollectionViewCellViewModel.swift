//
//  CharacterCollectionViewCellViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation
import Service

final class ComicCollectionViewCellViewModel: Hashable {

    // MARK: - Properties
    let title: String
    let id: Int
    private let imageUrl: URL?
    private let imageLoader: ImageLoaderProtocol = Services.make(for: ImageLoaderProtocol.self)

    // MARK: - Init
    init(
        title: String,
        id: Int,
        imageUrl: URL?
    ) {
        self.title = title
        self.id = id
        self.imageUrl = imageUrl
    }
}

// MARK: - Internal methods
extension ComicCollectionViewCellViewModel {
    func fetchImage(_ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        imageLoader.downloadImage(url, completion)
    }

    // MARK: - Hashable
    static func == (lhs: ComicCollectionViewCellViewModel, rhs: ComicCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(id)
        hasher.combine(imageUrl)
    }
}
