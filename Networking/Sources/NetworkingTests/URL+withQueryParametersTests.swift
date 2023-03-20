//
//  URL+withQueryParametersTests.swift
//  
//
//  Created by Luis Gustavo on 19/03/23.
//

import XCTest
@testable import Networking

final class URL_withQueryParametersTests: XCTestCase {

    func testCreateUrlWithQueryParameters() {
        // Given
        let queryParameters: [String: Any] = ["name": "Luis", "age": "25"]
        let url = URL(string: "https://www.google.com")!

        // When
        let newUrl = url.with(queryParameters: queryParameters)

        // Then
        XCTAssertNotNil(newUrl)
        XCTAssertEqual(newUrl?.absoluteString, "https://www.google.com?name=Luis&age=25")
    }

}
