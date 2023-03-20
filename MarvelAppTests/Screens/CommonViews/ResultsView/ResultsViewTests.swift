//
//  ResultsViewTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import SnapshotTesting
import XCTest
@testable import MarvelApp

final class ResultsViewTests: XCTestCase {

    private var mock: MockComicCollectionViewDelegate!
    private var sut: ResultsView!

    override func setUp() {
        super.setUp()
        mock = MockComicCollectionViewDelegate()
        sut = ResultsView(viewModel: .init(noResultsType: .cart))
        sut.collectionViewDelegate.delegate = mock
    }

    override func tearDown() {
        super.tearDown()
        mock = nil
        sut = nil
    }

    func testCollectionViewLayoutLightMode() throws {
        // Given
        sut.collectionView.isHidden = false
        sut.collectionView.alpha = 1
        sut.collectionView.reloadData()
        sut.overrideUserInterfaceStyle = .light

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }

    func testCollectionViewLayoutDarkMode() throws {
        // Given
        sut.collectionView.isHidden = false
        sut.collectionView.alpha = 1
        sut.collectionView.reloadData()
        sut.overrideUserInterfaceStyle = .dark

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }

    func testSpinnerLayoutLightMode() throws {
        // Given
        sut.spinner.isHidden = false
        sut.spinner.alpha = 1
        sut.overrideUserInterfaceStyle = .light

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }

    func testSpinnerLayoutDarkMode() throws {
        // Given
        sut.spinner.isHidden = false
        sut.spinner.alpha = 1
        sut.overrideUserInterfaceStyle = .dark

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }

    func testNoResultsLayoutLightMode() throws {
        // Given
        sut.noResultsView.isHidden = false
        sut.noResultsView.alpha = 1
        sut.overrideUserInterfaceStyle = .light

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }

    func testNoResultsLayoutDarkMode() throws {
        // Given
        sut.noResultsView.isHidden = false
        sut.noResultsView.alpha = 1
        sut.overrideUserInterfaceStyle = .dark

        // When
        sut.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        assertSnapshot(matching: sut, as: .image)
    }
}
