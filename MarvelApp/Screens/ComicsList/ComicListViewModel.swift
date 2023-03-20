//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation
import Networking
import Service

protocol ComicListViewModelDelegate: AnyObject {
    func loadedInitialComics()
    func loadedMoreComics(withOriginal originalCount: Int, andNewCount newCount: Int)
}

final class ComicListViewModel {

    // MARK: - Properties
    weak var delegate: ComicListViewModelDelegate?
    var showLoadMore: Bool {
        offset + count < total
    }
    var cellViewModels: [ComicCollectionViewCellViewModel] {
        comics.map { comic in
            return .init(
                title: comic.title,
                id: comic.id,
                imageUrl: comic.thumbnail.url
            )
        }
    }
    private var nextOffset: Int {
        showLoadMore ? offset + limit : offset
    }
    private let router: ComicListRouterProtocol
    private(set) var isLoadingMore = false
    private let comicProvider = ComicProvider()
    private let limit = 20
    private var count = 0
    private var offset = 0
    private var total = 0
    private var comics = [Comic]()

    // MARK: - Init
    init(router: ComicListRouterProtocol) {
        self.router = router
    }
}

// MARK: - Internal methods
extension ComicListViewModel {
    func fetchComics() {
        let queryParameters = ComicQueryParameters(offset: nextOffset, limit: limit)
        comicProvider.fetchComics(queryParameters: queryParameters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(success):
                for item in success.data.results where !self.comics.contains(item) {
                    self.comics.append(item)
                }
                self.count = success.data.count
                self.offset = success.data.offset
                self.total = success.data.total
                DispatchQueue.main.async {
                    self.delegate?.loadedInitialComics()
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
        comicProvider.fetchComics(queryParameters: queryParameters) { [weak self] result in
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

    func showComicDetail(at index: Int) {
        guard index < comics.count else { return }
        let comic = comics[index]
        router.showComicDetail(router, comic: comic)
    }

    func showSearch() {
        router.showSearch()
    }
}
