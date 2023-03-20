//
//  NoResultsViewTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import SnapshotTesting
import XCTest
@testable import MarvelApp

final class NoResultsViewTests: XCTestCase {

    private var sut: NoResultsView?

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testCartNoResultsView() throws {

        // Given
        sut = NoResultsView(viewModel: .init(type: .cart))

        // When
        sut?.frame = .init(origin: .zero, size: .init(width: 200, height: 200))

        // THen
        assertSnapshot(matching: sut!, as: .image)
    }

    func testFavoritesNoResultsView() throws {

        // Given
        sut = NoResultsView(viewModel: .init(type: .favorites))

        // When
        sut?.frame = .init(origin: .zero, size: .init(width: 200, height: 200))

        // THen
        assertSnapshot(matching: sut!, as: .image)
    }

    func testSearchNoResultsView() throws {

        // Given
        sut = NoResultsView(viewModel: .init(type: .search))

        // When
        sut?.frame = .init(origin: .zero, size: .init(width: 200, height: 200))

        // THen
        assertSnapshot(matching: sut!, as: .image)
    }
}
