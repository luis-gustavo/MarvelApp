//
//  AppRouter.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class AppRouter: AppRouterProtocol {

    // MARK: - Properties
    var navigationViewController: UINavigationController?
    var rootViewController: UINavigationController

    // MARK: - Init
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    // MARK: - ViewFactory
    func showTabBar() {
        let tabBarController = TabBarController(viewFactory: self)
        navigationViewController = tabBarController.comicListNavigationController
        rootViewController.setViewControllers([tabBarController], animated: true)
    }
}
