//
//  AppCoordinator.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol ViewFactory: ComicListRouterProtocol {
    var rootViewController: UINavigationController { get set }
    func showTabBar()
}

protocol ComicListRouterProtocol {
    var navigationViewController: UINavigationController? { get set }
    func showComicDetail(comic: Comic)
}

extension ViewFactory {
    func showComicDetail(comic: Comic) {
        let viewModel = ComicDetailViewModel(comic: comic)
        let viewController = ComicDetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationViewController?.pushViewController(viewController, animated: true)
    }
}

final class AppCoordinator: ViewFactory {

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
