//
//  FavoritesRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

protocol FavoritesRouterProtocol {
    var favoritesNavigationViewController: UINavigationController? { get set }
    func showComicDetail(_ sender: FavoritesRouterProtocol, comic: Comic)
}
