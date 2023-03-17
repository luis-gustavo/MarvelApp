//
//  CharacterListViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Networking
import UIKit

final class CharacterListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CharacterListViewModel

    // MARK: - UI Properties
    private lazy var characterListView: CharacterListView = {
        let view = CharacterListView()
        return view
    }()

    // MARK: - Inits
    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = characterListView
        title = "Characters"
    }
}
