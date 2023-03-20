//
//  ComicListViewModelTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Networking
import XCTest
@testable import MarvelApp

final class ComicListViewModelTests: XCTestCase {

    private var routerMock: MockComicListRouter!
    private var sut: ComicListViewModel!
    private var fetchExpectation: XCTestExpectation!
    private var expectationBlock: (() -> Void)?

    override func setUp() {
        routerMock = MockComicListRouter()
        sut = ComicListViewModel(router: routerMock)
        sut.delegate = self
    }

    override func tearDown() {
        routerMock = nil
        sut = nil
        fetchExpectation = nil
        expectationBlock = nil
    }

    func testTapFetchComics() {

        // Given
        fetchExpectation = expectation(description: "Fetched comics")

        // When
        expectationBlock = {
            XCTAssertEqual(self.sut.cellViewModels.count, 2)
            self.fetchExpectation.fulfill()
        }
        sut.fetchComics()

        // Then
        wait(for: [fetchExpectation], timeout: 1)
    }

    func testTapFetchAdditionalComics() {

        // Given
        fetchExpectation = expectation(description: "Fetched Additional comics")

        // When
        expectationBlock = {
            XCTAssertEqual(self.sut.cellViewModels.count, 2)
            self.fetchExpectation.fulfill()
        }
        sut.fetchAdditionalComics()

        // Then
        wait(for: [fetchExpectation], timeout: 1)
    }

    func testTapShowSearch() {

        // When
        sut.showSearch()

        // Then
        XCTAssertEqual(routerMock.tappedShowSearch, true)
    }

    func testTapShowComicDetail() {

        // Given
        fetchExpectation = expectation(description: "Fetched comics")

        // When
        expectationBlock = {
            // Then
            self.sut.showComicDetail(at: 0)
            XCTAssertEqual(self.routerMock.tappedShowComicDetail, true)
            self.fetchExpectation.fulfill()
        }
        sut.fetchComics()

        wait(for: [fetchExpectation], timeout: 5)
    }

}

extension ComicListViewModelTests: ComicListViewModelDelegate {
    func loadedInitialComics() {
        expectationBlock?()
    }

    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int) {
        expectationBlock?()
    }
}
