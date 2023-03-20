//
//  ComicCollectionViewTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import SnapshotTesting
import XCTest
@testable import MarvelApp

final class ComicCollectionViewTests: XCTestCase {

    private var sut: ComicCollectionView!
    private var mock: MockComicCollectionViewDelegate!
    private var collectionViewDelegate: ComicCollectionViewDataSource!

    override func setUp() {
        super.setUp()
        mock = MockComicCollectionViewDelegate()
        collectionViewDelegate = ComicCollectionViewDataSource()
        collectionViewDelegate.delegate = mock
        sut = ComicCollectionView()
        sut.delegate = collectionViewDelegate
        sut.dataSource = collectionViewDelegate
        sut.reloadData()
    }

    override func tearDown() {
        super.tearDown()
        mock = nil
        collectionViewDelegate = nil
        sut = nil
    }

    func testComicCollectionViewLayoutLightMode() {
        // Given
        let expectation = expectation(description: "Image loaded")
        sut.overrideUserInterfaceStyle = .light

        // When
        sut?.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            assertSnapshot(matching: self.sut!, as: .image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

    func testComicCollectionViewLayoutDarkMode() {
        // Given
        let expectation = expectation(description: "Image loaded")
        sut.overrideUserInterfaceStyle = .dark

        // When
        sut?.frame = .init(origin: .zero, size: .init(width: 500, height: 500))

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            assertSnapshot(matching: self.sut!, as: .image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
}
