//
//  MockCartRouter.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import UIKit
@testable import MarvelApp

final class MockCartRouter: CartRouterProtocol {

    var cartNavigationViewController: UINavigationController?
    var tappedShowComicDetail = false
    var tappedShowCheckout = false
    var comic: Comic?
    var comics: [Comic] = []

    func showComicDetail(_ sender: CartRouterProtocol, comic: Comic) {
        tappedShowComicDetail = true
        self.comic = comic
    }

    func showCheckout(_ sender: CartRouterProtocol, comics: [Comic]) {
        tappedShowCheckout = true
        self.comics = comics
    }
}
