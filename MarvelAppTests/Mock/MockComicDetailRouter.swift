//
//  MockComicDetailRouter.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import UIKit
@testable import MarvelApp

final class MockComicDetailRouter: ComicDetailRouterProtocol {

    var comicDetailContext: UIViewController?
    var tappedShowCheckout = false
    var comics = [Comic]()

    func showCheckout(sender: MarvelApp.ComicDetailRouterProtocol, comics: [MarvelApp.Comic]) {
        tappedShowCheckout = true
        self.comics = comics
    }
}
