//
//  FavoritesViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

final class FavoritesViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: FavoritesViewModel

    // MARK: - UI Properties
    private lazy var favoritesView: FavoritesView = {
        let view = FavoritesView(viewModel: viewModel)
        view.delegate = self
        return view
    }()

    // MARK: - Inits
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = favoritesView
        title = TabBarPage.favorite.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchComicsFromFavorites()
    }
}

// MARK: - FavoritesViewDelegate
extension FavoritesViewController: FavoritesViewDelegate {
    func didSelectComic(at position: Int) {
        viewModel.showComicDetail(at: position)
    }
}
