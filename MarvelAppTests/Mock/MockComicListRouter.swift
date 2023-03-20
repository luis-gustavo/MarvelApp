//
//  MockComicListRouter.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import UIKit
@testable import MarvelApp

final class MockComicListRouter: ComicListRouterProtocol {

    var comicListNavigationViewController: UINavigationController?
    var tappedShowComicDetail = false
    var tappedShowSearch = false

    func showComicDetail(_ sender: MarvelApp.ComicListRouterProtocol, comic: MarvelApp.Comic) {
        tappedShowComicDetail = true
    }

    func showSearch() {
        tappedShowSearch = true
    }
}
