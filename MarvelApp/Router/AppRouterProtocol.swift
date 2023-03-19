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
                            ComicDetailRouterProtocol,
                            LoginRouterProtocol {
    var rootViewController: UINavigationController { get set }
    func showLogin()
}

extension AppRouterProtocol {
    func showLogin() {
        let viewController = LoginViewController(viewModel: .init(router: self))
        rootViewController.setViewControllers([viewController], animated: true)
    }
}
