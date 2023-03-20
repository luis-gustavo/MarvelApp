//
//  EndPointTests.swift
//  
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation
import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {

    func testCreateRequest() {
        // Given
        let endpoint = MockEndpoint.mocked

        // When
        let request = endpoint.createRequest()

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request!.allHTTPHeaderFields, endpoint.headers)
        XCTAssertNil(request!.httpBody)
        XCTAssertEqual(request?.url?.absoluteString, "https://www.google.com?name=Luis")
    }
}

private enum MockEndpoint: EndPoint {

    case mocked

    var url: URL? {
        URL(string: "https://www.google.com")
    }

    var method: Networking.HTTPMethod {
        .get
    }

    var headers: [String: String] {
        ["Authorization": "token"]
    }

    var queryParameters: [String: Any] {
        ["name": "Luis"]
    }

    var body: Data? {
        return nil
    }
}
