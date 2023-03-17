//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Networking
import Service

final class CharacterListViewModel: CharacterListViewModelProtocol {

    private let networkService: URLSessionNetworkingProtocol = Services.make(for: URLSessionNetworkingProtocol.self)

    // MARK: - CharacterListViewModelProtocol
    func getCharacters() {
        networkService.request(endPoint: CharacterEndpoint.characters) { result in
            switch result {
            case let .success(success):
                print(String(data: success.data, encoding: .utf8))
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }

    func numberOfCharacters() -> Int {
        return 0
    }
}
