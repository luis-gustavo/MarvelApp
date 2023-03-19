//
//  AppRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol AppRouterProtocol: ComicListRouterProtocol, CartRouterProtocol, FavoritesRouterProtocol {
    var rootViewController: UINavigationController { get set }
    func showTabBar()
}

// MARK: - ComicListRouterProtocol
extension AppRouterProtocol {
    func showComicDetail(_ sender: ComicListRouterProtocol, comic: Comic) {
        showComicDetail(from: comicListNavigationViewController, comic: comic)
    }

    func showSearch() {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        comicListNavigationViewController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ComicListRouterProtocol
extension AppRouterProtocol {
    func showComicDetail(_ sender: CartRouterProtocol, comic: Comic) {
        showComicDetail(from: cartNavigationViewController, comic: comic)
    }
}

// MARK: - FavoritesRouterProtocol
extension AppRouterProtocol {
    func showComicDetail(_ sender: FavoritesRouterProtocol, comic: Comic) {
        showComicDetail(from: favoritesNavigationViewController, comic: comic)
    }
}

// MARK: - Private methods
private extension AppRouterProtocol {
    func showComicDetail(from navigationController: UINavigationController?, comic: Comic) {
        let viewModel = ComicDetailViewModel(comic: comic)
        let viewController = ComicDetailViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
