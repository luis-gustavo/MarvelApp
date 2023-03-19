//
//  FavoritesView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func didSelectComic(at position: Int)
}

final class FavoritesView: UIView {

    // MARK: - Properties
    weak var delegate: FavoritesViewDelegate?
    private let viewModel: FavoritesViewModel

    // MARK: - UI Properties
    private lazy var resultsView: ResultsView = {
        let view = ResultsView(viewModel: .init(noResultsType: .favorites))
        view.collectionViewDelegate.delegate = self
        return view
    }()

    // MARK: - Inits
    init(viewModel: FavoritesViewModel) {
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
extension FavoritesView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            resultsView
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            resultsView.topAnchor.constraint(equalTo: topAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}

// MARK: - ComicCollectionViewDataSourceProtocol
extension FavoritesView: FavoritesViewModelDelegate {
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

    func changedState(_ state: FavoritesViewModel.State) {

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
        resultsView.spinner.isHidden = !showSpinner
        resultsView.noResultsView.isHidden = !showNoResults

        UIView.animate(withDuration: 0.5) {
            self.resultsView.collectionView.alpha = showCollectionView ? 1 : 0
            self.resultsView.spinner.alpha = showSpinner ? 1 : 0
            self.resultsView.noResultsView.alpha = showNoResults ? 1 : 0
        }
    }
}

// MARK: - ComicCollectionViewDataSourceProtocol
extension FavoritesView: ComicCollectionViewDataSourceProtocol {
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
