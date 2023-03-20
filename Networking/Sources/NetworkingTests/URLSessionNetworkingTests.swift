//
//  URLSessionNetworkingTests.swift
//  
//
//  Created by Luis Gustavo on 19/03/23.
//

import XCTest
import Foundation
@testable import Networking

final class URLSessionNetworkingTests: XCTestCase {

    private let mock = MockUrlSessionNetworking()

    func testSuccessfulRequest() {
        // Given
        let expectation = expectation(description: "successful request")
        let endpoint = MockEndpoint.correct

        // When
        mock.request(endPoint: endpoint) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(endpoint.createRequest(), response.request)
                expectation.fulfill()
            case .failure:
                XCTFail("It shouldn't fail")
            }
        }

        // Then
        wait(for: [expectation], timeout: 1)
    }

    func testErrorRequest() {
        // Given
        let expectation = expectation(description: "successful request")
        let endpoint = MockEndpoint.wrong

        // When
        mock.request(endPoint: endpoint) { result in
            switch result {
            case . success:
                XCTFail("It should generate an error fail")
            case let .failure(error):
                XCTAssertEqual(error, .unableToCreateURL)
                expectation.fulfill()
            }
        }

        // Then
        wait(for: [expectation], timeout: 1)
    }
}

private final class MockUrlSessionNetworking: URLSessionNetworkingProtocol {
    func request(
        endPoint: Networking.EndPoint,
        _ completion: @escaping (Result<Networking.NetworkResponse, Networking.NetworkError>) -> Void
    ) {
        if let request = endPoint.createRequest() {
            completion(.success(.init(
                data: Data(),
                status: .okResponse,
                response: .init(),
                request: request
            )))
        } else {
            completion(.failure(.unableToCreateURL))
        }
    }
}

private enum MockEndpoint: EndPoint {
    case correct, wrong

    var url: URL? {
        switch self {
        case .correct:
            return .init(string: "https://www.google.com")
        case .wrong:
            return nil
        }
    }

    var method: Networking.HTTPMethod {
        .get
    }

    var headers: [String: String] {
        [:]
    }

    var queryParameters: [String: Any] {
        [:]
    }

    var body: Data? {
        nil
    }
}

private struct Mock: Codable {
    let age: Int
    let name: String
}
