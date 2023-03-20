//
//  ComicListViewControllerTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
import XCTest
import SnapshotTesting
@testable import MarvelApp

final class ComicListViewControllerTests: XCTestCase {

    private var routerMock: MockComicListRouter!
    private var sut: ComicListViewController!
    private var viewModel: ComicListViewModel!

    override func setUp() {
        super.setUp()
        routerMock = .init()
        viewModel = .init(router: routerMock)
        sut = .init(viewModel: viewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        routerMock = nil
        viewModel = nil
        sut = nil
    }

    func testInitialLoadingLightMode() {

        // Given
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .light

        // Then
        assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
    }

    func testInitialLoadingDarkMode() {

        // Given
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .dark

        // Then
        assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
    }

    func testResultsAfterFethcingLightMode() {

        // Given
        let expectation = expectation(description: "Comics fetched")
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .light

        // Then
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testResultsAfterFethcingDarkMode() {

        // Given
        let expectation = expectation(description: "Comics fetched")
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .dark

        // Then
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
