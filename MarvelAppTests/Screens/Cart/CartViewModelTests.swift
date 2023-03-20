//
//  CartViewModelTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
import XCTest
import SnapshotTesting
import Storage
import Service
@testable import MarvelApp

final class CartViewModelTests: XCTestCase {

    private var routerMock: MockCartRouter!
    private var sut: CartViewModel!

    override func setUp() {
        super.setUp()
        routerMock = .init()
        sut = .init(router: routerMock)
    }

    override func tearDown() {
        super.tearDown()
        routerMock = nil
        sut = nil
    }

    func testProceedToCheckout() {
        // When
        sut.proceedToCheckout()

        // Then
        XCTAssertTrue(routerMock.tappedShowCheckout)
        XCTAssertEqual(routerMock.comics, [])
    }
}
