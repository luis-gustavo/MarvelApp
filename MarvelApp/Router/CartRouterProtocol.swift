//
//  CartRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

protocol CartRouterProtocol {
    var cartNavigationViewController: UINavigationController? { get set }
    func showComicDetail(_ sender: CartRouterProtocol, comic: Comic)
    func showCheckout(_ sender: CartRouterProtocol, comics: [Comic])
}
