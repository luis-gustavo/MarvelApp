//
//  AppRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol AppRouterProtocol: ComicListRouterProtocol {
    var rootViewController: UINavigationController { get set }
    func showTabBar()
}

extension AppRouterProtocol {
    func showComicDetail(comic: Comic) {
        let viewModel = ComicDetailViewModel(comic: comic)
        let viewController = ComicDetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationViewController?.pushViewController(viewController, animated: true)
    }
}
