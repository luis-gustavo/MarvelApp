//
//  CartViewControllerTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import Foundation
import Networking
import XCTest
import SnapshotTesting
@testable import MarvelApp

final class CartViewControllerTests: XCTestCase {

    private var routerMock: MockCartRouter!
    private var sut: CartViewController!
    private var viewModel: CartViewModel!

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
