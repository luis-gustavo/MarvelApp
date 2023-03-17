//
//  CharacterListViewController.swift
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
        return view
    }()

    // MARK: - Inits
    init(viewModel: ComicListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = comicListView
        title = "Characters"
    }
}
