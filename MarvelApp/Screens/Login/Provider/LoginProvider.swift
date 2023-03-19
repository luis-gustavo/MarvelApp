//
//  LoginProvider.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation
import Networking

final class LoginProvider: LoginProviderProtocol {

    // MARK: - Properties
    static let shared = LoginProvider()

    // MARK: - Init
    private init() { }

    // MARK: - LoginProviderProtocol
    func login(
        with email: String,
        and password: String,
        _ completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval.random(in: 1...3), repeats: false) { timer in
            completion(.success(()))
            timer.invalidate()
        }
    }
}
