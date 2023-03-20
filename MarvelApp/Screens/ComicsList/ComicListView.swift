//
//  CharacterListView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import UIKit

protocol ComicListViewDelegate: AnyObject {
    func didSelectComic(at position: Int)
}

final class ComicListView: UIView {

    // MARK: - Properties
    weak var delegate: ComicListViewDelegate?
    private let viewModel: ComicListViewModel
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
        return view
    }()

    private lazy var collectionView: ComicCollectionView = {
        let view = ComicCollectionView()
        view.isHidden = true
        view.alpha = 0
        view.delegate = collectionViewDelegate
        view.dataSource = collectionViewDelegate
        return view
    }()

    // MARK: - Inits
    init(viewModel: ComicListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViewConfiguration()
        self.viewModel.delegate = self
        self.viewModel.fetchComics()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension ComicListView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            collectionView,
            spinner
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}

// MARK: - ComicListViewModelDelegate
extension ComicListView: ComicListViewModelDelegate {
    func loadedInitialComics() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView.alpha = 1
        }
    }

    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int) {
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
        }
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPathToAdd)
        }
    }
}

// MARK: - ComicCollectionViewDataSourceProtocol
extension ComicListView: ComicCollectionViewDataSourceProtocol {
    func didSelectComic(at index: Int) {
        delegate?.didSelectComic(at: index)
    }

    func shouldFetchMoreData() {
        viewModel.fetchAdditionalComics()
    }

    func showLoadMore() -> Bool {
        viewModel.showLoadMore
    }

    func isLoadingMore() -> Bool {
        viewModel.isLoadingMore
    }

    func cellViewModels() -> [ComicCollectionViewCellViewModel] {
        viewModel.cellViewModels
    }
}
