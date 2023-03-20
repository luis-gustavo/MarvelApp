//
//  MockUrlSessionNetworking.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Networking
import Foundation
@testable import MarvelApp

final class MockUrlSessionNetworking: URLSessionNetworkingProtocol {

    static let shared = MockUrlSessionNetworking()

    private init() { }

    func request(
        endPoint: EndPoint,
        _ completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void
    ) {
        let comics: [Comic] = [
            .init(
                id: 0,
                title: "Iron Man",
                thumbnail: .init(
                    path: "image",
                    extension: "png"
                ),
                issueNumber: 1,
                prices: [
                    .init(
                        price: 10,
                        type: "Print"
                    )
                ]
            ),
            .init(
                id: 1,
                title: "Captain America",
                thumbnail: .init(
                    path: "image",
                    extension: "png"
                ),
                issueNumber: 1,
                prices: [
                    .init(
                        price: 10,
                        type: "Print"
                    )
                ]
            )
        ]
        let comicData = ComicData(
            offset: 0,
            limit: 2,
            total: 2,
            count: 4,
            results: comics
        )
        let comicResponse = ComicResponse(data: comicData)
        let data = try? JSONEncoder().encode(comicResponse)
        let networkResponse = NetworkResponse(
            data: data!,
            status: .okResponse,
            response: HTTPURLResponse(),
            request: .init(url: .init(string: "http://google.com")!)
        )
        completion(.success(networkResponse))
    }
}
