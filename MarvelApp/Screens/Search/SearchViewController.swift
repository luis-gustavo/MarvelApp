//
//  SearchViewController.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: SearchViewModel

    // MARK: - UI Properties
    private lazy var searchView: SearchView = {
        let view = SearchView(viewModel: viewModel)
        return view
    }()

    // MARK: - Inits
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = .init(
            title: nil,
            image: .init(systemName: "calendar"),
            target: nil,
            action: nil,
            menu: createOptionsMenu()
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = searchView
        title = Localizable.search.localized
    }
}

// MARK: - Private methods
private extension SearchViewController {
    func createOptionsMenu() -> UIMenu {
        var options = (1939...2023).map { "\($0)" }
        options = options.reversed()
        options.insert(Localizable.removeFilter.localized, at: 0)
        let elements = options.map({ option in
            return UIAction(title: option) { [weak self] _ in
                self?.viewModel.updateYear(Int(option))
            }
        })
        return UIMenu(title: "", children: elements)
    }
}
