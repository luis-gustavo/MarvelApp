//
//  ComicDetailViewModelTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
import XCTest
import SnapshotTesting
@testable import MarvelApp

final class ComicDetailViewModelTests: XCTestCase {

    private var routerMock: MockComicDetailRouter!
    private var sut: ComicDetailViewModel!
    private let comic = Comic(
        id: 0,
        title: "Iron Man",
        thumbnail: .init(path: "", extension: ""),
        issueNumber: 101,
        prices: [.init(price: 9, type: "printPrice")])

    override func setUp() {
        super.setUp()
        routerMock = .init()
        sut = .init(router: routerMock, comic: comic)
    }

    override func tearDown() {
        super.tearDown()
        routerMock = nil
        sut = nil
    }

    func testPropertiesValues() {
        XCTAssertEqual(comic.title, sut.title)
        XCTAssertEqual(comic.thumbnail.url, sut.imageUrl)
        XCTAssertEqual("\(Localizable.price.localized): $9.0", sut.price)
        XCTAssertEqual("\(Localizable.issue.localized) #101", sut.issue)
        XCTAssertFalse(sut.isFavorited)
        XCTAssertFalse(sut.isOnCart)
    }

    func testProceedToCheckout() {
        // When
        sut.proceedToCheckout()

        // Then
        XCTAssertTrue(routerMock.tappedShowCheckout)
        XCTAssertEqual(routerMock.comics, [comic])
    }

    func testFavorite() {
        // When
        let newValue = sut.changeFavoriteStatus(selected: true)

        // Then
        XCTAssertTrue(newValue)
    }

    func testAddToCart() {
        // When
        let newValue = sut.changeCartStatus(selected: true)

        // Then
        XCTAssertTrue(newValue)
    }
}
