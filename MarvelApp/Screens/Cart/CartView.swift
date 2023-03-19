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
    private lazy var resultsView: ResultsView = {
        let view = ResultsView(viewModel: .init(noResultsType: .cart))
        view.collectionViewDelegate.delegate = self
        return view
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitleColor(.label, for: .normal)
        button.setTitle(Localizable.buy.localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addAction(UIAction { [weak self]  _ in
            self?.viewModel.proceedToCheckout()
        }, for: .touchUpInside)
        return button
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
            resultsView,
            buyButton
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -32),

            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            buyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            buyButton.heightAnchor.constraint(equalToConstant: 56)
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
        resultsView.collectionView.performBatchUpdates {
            self.resultsView.collectionView.insertItems(at: indexPathToAdd)
        }
    }

    func changedState(_ state: CartViewModel.State) {

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

        resultsView.collectionView.isHidden = !showCollectionView
        buyButton.isHidden = !showCollectionView
        resultsView.spinner.isHidden = !showSpinner
        resultsView.noResultsView.isHidden = !showNoResults

        UIView.animate(withDuration: 0.5) {
            self.resultsView.collectionView.alpha = showCollectionView ? 1 : 0
            self.buyButton.alpha = showCollectionView ? 1 : 0
            self.resultsView.spinner.alpha = showSpinner ? 1 : 0
            self.resultsView.noResultsView.alpha = showNoResults ? 1 : 0
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
