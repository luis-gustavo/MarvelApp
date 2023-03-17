//
//  MainCoordinator.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

final class MainCoordinator: Coordinatable {

    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinatable
    func start() {
        navigationController.setViewControllers([TabBarController()], animated: true)
    }
}
