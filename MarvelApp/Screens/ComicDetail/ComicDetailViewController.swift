//
//  ComicDetailViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class ComicDetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: ComicDetailViewModel

    // MARK: - UI Properties
    private lazy var comicDetailView: ComicDetailView = {
        let view = ComicDetailView(viewModel: viewModel)
        return view
    }()

    // MARK: - Inits
    init(viewModel: ComicDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = comicDetailView
        title = viewModel.title
    }
}
