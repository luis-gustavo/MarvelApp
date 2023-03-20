//
//  MockLoginProvider.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
@testable import MarvelApp

final class MockLoginProvider: LoginProviderProtocol {

    static let shared = MockLoginProvider()

    private init() { }

    func login(
        with email: String,
        and password: String,
        _ completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {

    }
}
