//
//  ComicProvider.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation
import Networking
import Service

final class ComicProvider {

    // MARK: - Properties
    private let networkService: URLSessionNetworkingProtocol = Services.make(for: URLSessionNetworkingProtocol.self)

    // MARK: - ComicProviderProtocol
    func fetchComics(queryParameters: ComicQueryParameters, _ completion: @escaping (Result<ComicResponse, NetworkError>) -> Void) {
        networkService.request(endPoint: ComicEndpoint.comics(queryParameters: queryParameters)) { result in
            switch result {
            case let .success(success):
                do {
                    let response = try JSONDecoder().decode(ComicResponse.self, from: success.data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.unmapped(error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
