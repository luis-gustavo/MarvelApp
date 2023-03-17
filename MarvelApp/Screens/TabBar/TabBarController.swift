//
//  TabBarController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
}

// MARK: - Private methods
private extension TabBarController {
    func setupTabs() {
        let characterListViewController = ComicListViewController(
            viewModel: .init()
        )
        characterListViewController.navigationItem.largeTitleDisplayMode = .automatic
        let characterListNavigationController = UINavigationController(rootViewController: characterListViewController)
        characterListNavigationController.navigationBar.prefersLargeTitles = true
        characterListNavigationController.tabBarItem = UITabBarItem(
            title: "Characters",
            image: .init(systemName: "person"),
            tag: 1
        )
        setViewControllers([characterListNavigationController], animated: true)
    }
}
