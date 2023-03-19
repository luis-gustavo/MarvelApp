//
//  SearchView.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

final class SearchView: UIView {

    // MARK: - Properties
    private let viewModel: SearchViewModel

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

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        view.becomeFirstResponder()
        view.returnKeyType = .search
        view.delegate = self
        view.showsCancelButton = true
        view.searchTextField.delegate = self
        return view
    }()

    private let noResultsView: NoResultsView = {
        let view = NoResultsView(viewModel: .init(type: .search))
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private lazy var collectionView: ComicCollectionView = {
        let view = ComicCollectionView()
        view.isHidden = true
        view.alpha = 0
        view.delegate = collectionViewDelegate
        view.dataSource = collectionViewDelegate
        view.keyboardDismissMode = .onDrag
        return view
    }()

    // MARK: - Inits
    init(viewModel: SearchViewModel) {
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
extension SearchView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews(
            spinner,
            searchBar,
            noResultsView,
            collectionView
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),

            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noResultsView.heightAnchor.constraint(equalToConstant: 200),
            noResultsView.widthAnchor.constraint(equalTo: noResultsView.heightAnchor),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}

// MARK: - UISearchBarDelegate
extension SearchView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchBar(searchBar, textDidChange: "")
        viewModel.clearSearch()
    }
}

// MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.fetchComics()
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - SearchViewModelDelegate
extension SearchView: SearchViewModelDelegate {
    func loadedComics() {
        collectionView.reloadData()
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

    func changedState(_ state: SearchViewModel.SearchState) {

        let showCollectionView: Bool
        let showSpinner: Bool
        let showNoResults: Bool

        switch state {
        case .idle:
            showCollectionView = true
            showSpinner = false
            showNoResults = false
        case .fetching:
            showCollectionView = false
            showSpinner = true
            showNoResults = false
        case .results:
            showCollectionView = !viewModel.cellViewModels.isEmpty
            showSpinner = false
            showNoResults = viewModel.cellViewModels.isEmpty
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
extension SearchView: ComicCollectionViewDataSourceProtocol {
    func didSelectComic(at index: Int) { }

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
