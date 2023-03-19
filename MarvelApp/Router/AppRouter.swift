//
//  AppRouter.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class AppRouter: AppRouterProtocol {

    // MARK: - Properties
    var rootViewController: UINavigationController
    var comicListNavigationViewController: UINavigationController?
    var cartNavigationViewController: UINavigationController?

    // MARK: - Init
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    // MARK: - ViewFactory
    func showTabBar() {
        let tabBarController = TabBarController(appRouter: self)
        comicListNavigationViewController = tabBarController.comicListNavigationController
        cartNavigationViewController = tabBarController.cartNavigationController
        rootViewController.setViewControllers([tabBarController], animated: true)
    }
}
