//
//  SearchViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func loadedComics()
    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int)
    func changedState(_ state: SearchViewModel.SearchState)
}

final class SearchViewModel {

    // MARK: - SearchState
    enum SearchState {
        case idle, fetching, results
    }

    // MARK: - Properties
    weak var delegate: SearchViewModelDelegate?
    var cellViewModels: [ComicCollectionViewCellViewModel] {
        comics.map { comic in
            return .init(
                title: comic.title,
                id: comic.id,
                imageUrl: comic.thumbnail.url
            )
        }
    }
    private var state: SearchState = .idle {
        didSet {
            delegate?.changedState(state)
        }
    }
    private(set) var isLoadingMore = false
    private let provider = ComicProvider()
    private var searchText = ""
    private var year: Int?
    private var offset = 0
    private var count = 0
    private var total = 0
    private let limit = 20
    private var comics = [Comic]()
    var showLoadMore: Bool {
        offset + count < total
    }
    private var nextOffset: Int {
        showLoadMore ? offset + limit : offset
    }
}

// MARK: - Internal methods
extension SearchViewModel {
    func updateSearchText(_ searchText: String) {
        self.searchText = searchText
    }

    func updateYear(_ year: Int?) {
        self.year = year
        cleanQueryParameters()
        fetchComics()
    }

    func fetchComics() {
//        guard !searchText.isEmpty else { return }
        state = .fetching
        let queryParameters = ComicQueryParameters(
            offset: nextOffset,
            limit: limit,
            text: searchText.isEmpty ? nil : searchText,
            year: year
        )
        provider.fetchComics(queryParameters: queryParameters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(success):
                for item in success.data.results where !self.comics.contains(item) {
                    self.comics.append(item)
                }
                if success.data.results.isEmpty {
                    DispatchQueue.main.async {
                        self.cleanQueryParameters()
                        self.state = .results
                    }
                    return
                }
                self.count = success.data.count
                self.offset = success.data.offset
                self.total = success.data.total
                DispatchQueue.main.async {
                    self.state = .results
                    self.delegate?.loadedComics()
                }
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }

    func fetchAdditionalComics() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        let queryParameters = ComicQueryParameters(offset: nextOffset, limit: limit)
        provider.fetchComics(queryParameters: queryParameters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(success):
                let originalCount = self.comics.count
                for item in success.data.results where !self.comics.contains(item) {
                    self.comics.append(item)
                }
                let newCount = self.comics.count - originalCount
                self.count = success.data.count
                self.offset = success.data.offset
                self.total = success.data.total
                DispatchQueue.main.async {
                    self.delegate?.loadedMoreComics(withOriginal: originalCount, andNewCount: newCount)
                    self.isLoadingMore = false
                }
            case let .failure(failure):
                print(failure.localizedDescription)
                self.isLoadingMore = false
            }
        }
    }

    func clearSearch() {
        cleanQueryParameters()
        state = .idle
    }
}

// MARK: - Private methods
private extension SearchViewModel {
    func cleanQueryParameters() {
        offset = 0
        count = 0
        total = 0
        comics.removeAll()
        delegate?.loadedComics()
    }
}
