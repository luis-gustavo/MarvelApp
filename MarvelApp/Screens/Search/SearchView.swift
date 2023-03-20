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
    private lazy var resultsView: ResultsView = {
        let view = ResultsView(viewModel: .init(noResultsType: .search))
        view.collectionViewDelegate.delegate = self
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = Localizable.search.localized
        view.becomeFirstResponder()
        view.returnKeyType = .search
        view.delegate = self
        view.showsCancelButton = true
        view.searchTextField.delegate = self
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
            resultsView,
            searchBar
        )
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            resultsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
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
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - SearchViewModelDelegate
extension SearchView: SearchViewModelDelegate {
    func loadedComics() {
        resultsView.collectionView.reloadData()
    }

    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int) {
        let total = originalCount + newCount
        let startingIndex = total - newCount
        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
            return IndexPath(row: $0, section: 0)
        }
        resultsView.collectionView.performBatchUpdates {
            self.resultsView.collectionView.insertItems(at: indexPathToAdd)
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
