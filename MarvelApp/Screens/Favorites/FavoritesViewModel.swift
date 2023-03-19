//
//  FavoritesViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import Foundation
import Service
import Storage

protocol FavoritesViewModelDelegate: AnyObject {
    func loadedComics(originalCount: Int, newCount: Int)
    func changedState(_ state: FavoritesViewModel.State)
}

final class FavoritesViewModel {

    // MARK: - State
    enum State {
        case fetching, results, noItems
    }

    // MARK: - Properties
    var cellViewModels: [ComicCollectionViewCellViewModel] {
        comics.map { comic in
            return .init(
                title: comic.title,
                id: comic.id,
                imageUrl: comic.thumbnail.url
        )}
    }
    weak var delegate: FavoritesViewModelDelegate?
    private let router: FavoritesRouterProtocol
    private var state: State = .fetching {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.changedState(self.state)
            }
        }
    }
    private let storage: Storage = Services.make(for: Storage.self)
    private let comicProvider = ComicProvider()
    private var comics = [Comic]()
    private var cachedIds = [Int]()

    // MARK: - Init
    init(router: FavoritesRouterProtocol) {
        self.router = router
    }
}

// MARK: - Internal methods
extension FavoritesViewModel {
    func fetchComicsFromFavorites() {
        let ids = favoritesComicsIds()
        guard !ids.isEmpty else {
            state = .noItems
            return
        }
        guard cachedIds != ids else { return }
        cachedIds = ids
        comics.removeAll()
        state = .fetching
        for id in ids {
            comicProvider.fetchComic(by: id) { [weak self] result in
                self?.state = .results
                switch result {
                case let .success(comic):
                    let originalCount = self?.comics.count ?? 0
                    self?.comics.append(comic)
                    let newCount = (self?.comics.count ?? 0) - originalCount
                    DispatchQueue.main.async {
                        self?.delegate?.loadedComics(originalCount: originalCount, newCount: newCount)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func showComicDetail(at index: Int) {
        let comic = comics[index]
        router.showComicDetail(router, comic: comic)
    }
}

// MARK: - Private methods
private extension FavoritesViewModel {
    func favoritesComicsIds() -> [Int] {
        switch storage.read(from: .favorite) {
        case let .success(rows):
            return rows.map { $0.model }
        case .failure:
            return []
        }
    }
}
