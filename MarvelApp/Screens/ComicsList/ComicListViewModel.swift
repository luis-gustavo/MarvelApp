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
    private var comics = Set<Comic>() {
        didSet {
            for item in comics {
                let viewModel = ComicCollectionViewCellViewModel(
                    title: item.title,
                    id: item.id,
                    imageUrl: item.thumbnail.url
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    private(set) var cellViewModels: [ComicCollectionViewCellViewModel] = []

    // MARK: - Init
    init(router: ComicListRouterProtocol) {
        self.router = router
    }
}

// MARK: - Internal methods

extension ComicListViewModel {
    func fetchComics() {
        comicProvider.fetchComics(offset: nextOffset, limit: limit) { [weak self] result in
            switch result {
            case let .success(success):
                for item in success.data.results {
                    self?.comics.insert(item)
                }
                self?.count = success.data.count
                self?.offset = success.data.offset
                self?.total = success.data.total
                DispatchQueue.main.async {
                    self?.delegate?.loadedInitialComics()
                }
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }

    func fetchAdditionalComics() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        comicProvider.fetchComics(offset: nextOffset, limit: limit) { [weak self] result in
            switch result {
            case let .success(success):
                let originalCount = self?.comics.count ?? 0
                for item in success.data.results {
                    self?.comics.insert(item)
                }
                let newCount = (self?.comics.count ?? 0) - originalCount
                self?.count = success.data.count
                self?.offset = success.data.offset
                self?.total = success.data.total
                DispatchQueue.main.async {
                    self?.delegate?.loadedMoreComics(withOriginal: originalCount, andNewCount: newCount)
                    self?.isLoadingMore = false
                }
            case let .failure(failure):
                print(failure.localizedDescription)
                self?.isLoadingMore = false
            }
        }
    }

    func showComicDetail(at index: Int) {
        let cellViewModel = cellViewModels[index]
        guard let comic = comics.first(where: { $0.id == cellViewModel.id }) else { return }
        router.showComicDetail(comic: comic)
    }
}
