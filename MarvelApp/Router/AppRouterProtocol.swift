//
//  AppRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol AppRouterProtocol: ComicListRouterProtocol,
                            CartRouterProtocol,
                            FavoritesRouterProtocol,
                            ComicDetailRouterProtocol {
    var rootViewController: UINavigationController { get set }
    func showTabBar()
}
