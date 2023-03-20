//
//  URLSessionNetworkingTests.swift
//  
//
//  Created by Luis Gustavo on 19/03/23.
//

//import Foundation
import XCTest
@testable import Networking

final class URLSessionNetworkingTests: XCTestCase {

    func testExample()  {
        // Given
        let endpoint = MockEndpoint.mock

        // When
        URLSessionNetworking.shared.request(endPoint: endpoint) { result in
            switch result {
            case let .success(response):
                let mocked = try? JSONDecoder().decode(Mock.self, from: response.data)
                XCTAssertNotNil(mocked)
                XCTAssertEqual(mocked?.age, 25)
                XCTAssertEqual(mocked?.name, "Luis")
            case .failure:
                XCTFail()
            }
        }
    }
}

private enum MockEndpoint: EndPoint {
    case mock

    var url: URL? {
        let bundle = Bundle.module
        let fileURL = bundle.url(forResource: "person", withExtension: "json")!
        return fileURL
    }

    var method: Networking.HTTPMethod {
        .get
    }

    var headers: [String : String] {
        [:]
    }

    var queryParameters: [String : Any] {
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
