//
//  ComicDetailViewControllerTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
import XCTest
import SnapshotTesting
@testable import MarvelApp

final class ComicDetailViewControllerTests: XCTestCase {

    private var routerMock: MockComicDetailRouter!
    private var sut: ComicDetailViewController!
    private var viewModel: ComicDetailViewModel!
    private let comic = Comic(
        id: 0,
        title: "Iron Man",
        thumbnail: .init(path: "", extension: ""),
        issueNumber: 101,
        prices: [.init(price: 9, type: "Digital")])

    override func setUp() {
        super.setUp()
        routerMock = .init()
        viewModel = .init(router: routerMock, comic: comic)
        sut = .init(viewModel: viewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        routerMock = nil
        viewModel = nil
        sut = nil
    }

    func testComicDetailLayoutLightMode() {
        // Given
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .light

        // Then
        assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
    }

    func testComicDetailLayoutDarkMode() {
        // Given
        let navigationController = UINavigationController(rootViewController: sut)
        sut.overrideUserInterfaceStyle = .dark

        // Then
        assertSnapshot(matching: navigationController, as: .image(on: .iPhoneX))
    }
}
