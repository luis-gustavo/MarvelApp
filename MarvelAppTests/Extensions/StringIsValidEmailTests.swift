//
//  StringIsValidEmailTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import XCTest
@testable import MarvelApp

final class StringIsValidEmailTests: XCTestCase {

    func testIsValidEmail() {

        // Given
        let validEmail = "luis@gmail.com"

        // When
        let isValid = validEmail.isValidEmail

        // Then
        XCTAssertEqual(isValid, true)
    }

    func testIsntValidEmail() {

        // Given
        let invalidEmail = "luis132.abc"

        // When
        let isValid = invalidEmail.isValidEmail

        // Then
        XCTAssertEqual(isValid, false)
    }
}
