//
//  ComicsListViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Networking
import UIKit

final class ComicListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: ComicListViewModel

    // MARK: - UI Properties
    private lazy var comicListView: ComicListView = {
        let view = ComicListView(viewModel: viewModel)
        view.delegate = self
        return view
    }()

    // MARK: - Inits
    init(viewModel: ComicListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = comicListView
        title = TabBarPage.comics.title
    }
}

// MARK: - ComicListViewDelegate
extension ComicListViewController: ComicListViewDelegate {
    func didSelectComic(at position: Int) {
        viewModel.showComicDetail(at: position)
    }
}

// MARK: - Targets
private extension ComicListViewController {
    @objc func didTapSearch() {
        viewModel.showSearch()
    }
}
