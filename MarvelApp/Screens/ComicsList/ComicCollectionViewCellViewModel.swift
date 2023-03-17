//
//  CharacterCollectionViewCellViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

final class CharacterCollectionViewCellViewModel {

    // MARK: - Properties
    let name: String
    private let imageUrl: URL?

    // MARK: - Init
    init(
        name: String,
        imageUrl: URL?
    ) {
        self.name = name
        self.imageUrl = imageUrl
    }
}

// MARK: - Internal methods
extension CharacterCollectionViewCellViewModel {
    func fetchImage(_ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
