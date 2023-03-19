//
//  LoginProviderProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Networking

protocol LoginProviderProtocol {
    func login(
        with email: String,
        and password: String,
        _ completion: @escaping (Result<Void, NetworkError>) -> Void
    )
}
