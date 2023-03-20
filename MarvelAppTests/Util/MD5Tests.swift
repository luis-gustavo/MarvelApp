//
//  MD5Tests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 19/03/23.
//

import XCTest
@testable import MarvelApp

final class MD5Tests: XCTestCase {

    func testMD5() {
        // Given
        let hash = "233eb7b67b712155db8b6dd07d17872b"

        // When
        let md5Hash = md5(hash)

        // Then
        XCTAssertEqual("b4cd386352cc058b35537dbe8d43fcab", md5Hash)
    }
}
