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

    private let noResultsView: NoSearchResultsView = {
        let view = NoSearchResultsView()
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        view.alpha = 0
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.register(
            ComicCollectionViewCell.self,
            forCellWithReuseIdentifier: ComicCollectionViewCell.identifier
        )
        view.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )
        view.delegate = self
        view.dataSource = self
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
//        collectionView.isHidden = viewModel.cellViewModels.isEmpty
//        noResultsView.isHidden = !viewModel.cellViewModels.isEmpty
//        UIView.animate(withDuration: 0.5) { [weak self] in
//            guard let self else { return }
//            self.collectionView.alpha = self.viewModel.cellViewModels.isEmpty ? 0 : 1
//            self.noResultsView.alpha = self.viewModel.cellViewModels.isEmpty ? 1 : 0
//        }
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SearchView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicCollectionViewCell.identifier,
            for: indexPath
        ) as? ComicCollectionViewCell else {
            return .init()
        }
        let cellViewModel = viewModel.cellViewModels[indexPath.item]
        cell.configure(with: cellViewModel)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width - 42) / 2
        return .init(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
            for: indexPath)

        return footer
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        guard viewModel.showLoadMore else {
            return .zero
        }
        return .init(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.didSelectComic(at: indexPath.item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.showLoadMore,
              !viewModel.isLoadingMore else { return }
        let yOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewFixedHeight = scrollView.frame.size.height

        if yOffset >= (contentHeight - scrollViewFixedHeight - 120) {
            viewModel.fetchAdditionalComics()
        }
    }
}
