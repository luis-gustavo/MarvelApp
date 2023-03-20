//
//  MockImageLoader.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
@testable import MarvelApp

final class MockImageLoader: ImageLoaderProtocol {

    static let shared = MockImageLoader()

    private init() { }

    func downloadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        let bundle = Bundle(for: ImageLoaderTests.self)
        let url = bundle.url(forResource: "logo", withExtension: "png")!
        let data = try? Data(contentsOf: url)
        completion(.success(data!))
    }
}
