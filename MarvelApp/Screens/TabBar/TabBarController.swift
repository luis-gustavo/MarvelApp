//
//  TabBarController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Properties
    private let viewFactory: AppRouterProtocol
    private(set) lazy var comicListViewController: ComicListViewController = {
        let viewController = ComicListViewController(viewModel: .init(router: viewFactory))
        viewController.navigationItem.largeTitleDisplayMode = .automatic
        return viewController
    }()
    private(set) lazy var comicListNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: comicListViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: TabBarPage.comics.title,
            image: TabBarPage.comics.image,
            tag: 1
        )
        return navigationController
    }()

    // MARK: - Inits
    init(viewFactory: AppRouterProtocol) {
        self.viewFactory = viewFactory
        super.init(nibName: nil, bundle: nil)
        setViewControllers([comicListNavigationController], animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
