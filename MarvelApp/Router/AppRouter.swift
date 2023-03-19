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
    var favoritesNavigationViewController: UINavigationController?
    var comicDetailContext: UIViewController?

    // MARK: - Init
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    // MARK: - ViewFactory
    func showMainView() {
        let tabBarController = TabBarController(appRouter: self)
        comicListNavigationViewController = tabBarController.comicListNavigationController
        cartNavigationViewController = tabBarController.cartNavigationController
        favoritesNavigationViewController = tabBarController.favoritesNavigationController
        rootViewController.setViewControllers([tabBarController], animated: true)
    }
}

extension AppRouter {
    func showComicDetail(_ sender: ComicListRouterProtocol, comic: Comic) {
        showComicDetail(with: sender.comicListNavigationViewController, comic: comic)
    }

    func showComicDetail(_ sender: CartRouterProtocol, comic: Comic) {
        showComicDetail(with: sender.cartNavigationViewController, comic: comic)
    }

    func showComicDetail(_ sender: FavoritesRouterProtocol, comic: Comic) {
        showComicDetail(with: sender.favoritesNavigationViewController, comic: comic)
    }

    func showCheckout(_ sender: CartRouterProtocol, comics: [Comic]) {
        showCheckout(comics: comics)
    }

    func showCheckout(sender: ComicDetailRouterProtocol, comics: [Comic]) {
        showCheckout(comics: comics)
    }
}

// MARK: - Private methods
private extension AppRouter {
    func showComicDetail(with context: UINavigationController?, comic: Comic) {
        comicDetailContext = context
        let viewModel = ComicDetailViewModel(router: self, comic: comic)
        let viewController = ComicDetailViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        context?.pushViewController(viewController, animated: true)
    }

    func showCheckout(comics: [Comic]) {
        let alertController = UIAlertController(
            title: Localizable.checkout.localized,
            message: Localizable.checkoutMessage.localized,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: Localizable.okMessage.localized, style: .default))
        comicDetailContext?.present(alertController, animated: true)
    }
}
