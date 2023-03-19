//
//  TabBarController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Properties
    private let appRouter: AppRouterProtocol

    // View Controllers
    private(set) lazy var comicListViewController: ComicListViewController = {
        let viewController = ComicListViewController(viewModel: .init(router: appRouter))
        viewController.navigationItem.largeTitleDisplayMode = .automatic
        return viewController
    }()

    private lazy var favoritesViewController: FavoritesViewController = {
        let viewController = FavoritesViewController(viewModel: .init(router: appRouter))
        viewController.navigationItem.largeTitleDisplayMode = .automatic
        return viewController
    }()

    private lazy var cartViewController: CartViewController = {
        let viewController = CartViewController(viewModel: .init(router: appRouter))
        viewController.navigationItem.largeTitleDisplayMode = .automatic
        return viewController
    }()

    // Navigation Controllers
    private(set) lazy var comicListNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: comicListViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: TabBarPage.comics.title,
            image: TabBarPage.comics.image,
            tag: TabBarPage.comics.tag
        )
        return navigationController
    }()

    private(set) lazy var favoritesNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: favoritesViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: TabBarPage.favorite.title,
            image: TabBarPage.favorite.image,
            tag: TabBarPage.favorite.tag
        )
        return navigationController
    }()

    private(set) lazy var cartNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: cartViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: TabBarPage.cart.title,
            image: TabBarPage.cart.image,
            tag: TabBarPage.cart.tag
        )
        return navigationController
    }()

    // MARK: - Inits
    init(appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
        super.init(nibName: nil, bundle: nil)
        setViewControllers(
            [
                comicListNavigationController,
                favoritesNavigationController,
                cartNavigationController
            ],
            animated: true
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
