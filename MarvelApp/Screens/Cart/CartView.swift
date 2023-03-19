//
//  CartView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 18/03/23.
//

import UIKit

protocol CartViewDelegate: AnyObject {
    func didSelectComic(at position: Int)
}

final class CartView: UIView {

    // MARK: - Properties
    weak var delegate: CartViewDelegate?
    private let viewModel: CartViewModel

    private lazy var collectionViewDelegate: ComicCollectionViewDataSource = {
        let comicCollectionViewDataSource = ComicCollectionViewDataSource()
        comicCollectionViewDataSource.delegate = self
        return comicCollectionViewDataSource
    }()

    // MARK: - UI Properties
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private lazy var collectionView: ComicCollectionView = {
        let view = ComicCollectionView()
        view.delegate = collectionViewDelegate
        view.dataSource = collectionViewDelegate
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private let noResultsView: NoResultsView = {
        let view = NoResultsView(viewModel: .init(type: .cart))
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    // MARK: - Inits
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension CartView: ViewCodable {
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

// MARK: - ComicCollectionViewDataSourceProtocol
extension CartView: CartViewModelDelegate {
    func loadedComics(originalCount: Int, newCount: Int) {
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
        }
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPathToAdd)
        }
    }

    func changedState(_ state: CartViewModel.CartState) {

        let showCollectionView: Bool
        let showSpinner: Bool
        let showNoResults: Bool

        switch state {
        case .fetching:
            showCollectionView = false
            showSpinner = true
            showNoResults = false
        case .results:
            showCollectionView = true
            showSpinner = false
            showNoResults = false
        case .noItems:
            showCollectionView = false
            showSpinner = false
            showNoResults = true
        }

        collectionView.isHidden = !showCollectionView
        spinner.isHidden = !showSpinner
        noResultsView.isHidden = !showNoResults

        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = showCollectionView ? 1 : 0
            self.spinner.alpha = showSpinner ? 1 : 0
            self.noResultsView.alpha = showNoResults ? 1 : 0
        }
    }
}

// MARK: - ComicCollectionViewDataSourceProtocol
extension CartView: ComicCollectionViewDataSourceProtocol {
    func didSelectComic(at index: Int) {
        delegate?.didSelectComic(at: index)
    }

    func shouldFetchMoreData() { }

    func showLoadMore() -> Bool { false }

    func isLoadingMore() -> Bool { false }

    func cellViewModels() -> [ComicCollectionViewCellViewModel] {
        viewModel.cellViewModels
    }
}
