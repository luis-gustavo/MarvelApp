//
//  ResultsView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

final class ResultsView: UIView {

    // MARK: - Properties
    private let viewModel: ResultsViewModel

    private(set) lazy var collectionViewDelegate = ComicCollectionViewDataSource()

    // MARK: - UI Properties
    private(set) lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private(set) lazy var collectionView: ComicCollectionView = {
        let view = ComicCollectionView()
        view.delegate = collectionViewDelegate
        view.dataSource = collectionViewDelegate
        view.isHidden = true
        view.alpha = 0
        view.keyboardDismissMode = .onDrag
        return view
    }()

    private(set) lazy var noResultsView: NoResultsView = {
        let view = NoResultsView(viewModel: .init(type: viewModel.noResultsType))
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    // MARK: - Init
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension ResultsView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            collectionView,
            spinner,
            noResultsView
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),

            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsView.heightAnchor.constraint(equalToConstant: 200),
            noResultsView.widthAnchor.constraint(equalTo: noResultsView.heightAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}
