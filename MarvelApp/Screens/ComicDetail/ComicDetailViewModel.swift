//
//  ComicDetailViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation
import Service
import Storage

final class ComicDetailViewModel {

    // MARK: - Properties
    var title: String { comic.title }
    var imageUrl: URL? { comic.thumbnail.url }
    var price: String { comic.prices.map { "\($0.typeTitle): $\($0.price)" }.joined(separator: "\n") }
    var issue: String { "Issue #\(comic.issueNumber)" }
    var isFavorited: Bool {
        favorites().contains(comic.id)
    }
    var isOnCart: Bool {
        cart().contains(comic.id)
    }
    private let comic: Comic
    private let storage: Storage = Services.make(for: Storage.self)

    // MARK: - Inits
    init(comic: Comic) {
        self.comic = comic
    }
}

// MARK: - Internal methods
extension ComicDetailViewModel {
    func changeFavoriteStatus(selected: Bool) -> Bool {
        changeStatus(selected: selected, table: .favorite)
    }

    func changeCartStatus(selected: Bool) -> Bool {
        changeStatus(selected: selected, table: .cart)
    }
}

// MARK: - Private methods
private extension ComicDetailViewModel {
    func favorites() -> [Int] {
        switch storage.read(from: .favorite) {
        case let .success(rows):
            return rows.map { $0.model }
        case .failure:
            return []
        }
    }

    func cart() -> [Int] {
        switch storage.read(from: .cart) {
        case let .success(rows):
            return rows.map { $0.model }
        case .failure:
            return []
        }
    }

    func changeStatus(selected: Bool, table: StorageTable) -> Bool {
        if selected {
            var ids = table == .favorite ? favorites() : cart()
            ids.append(comic.id)
            let result = storage.write(ids: ids, on: table)
            switch result {
            case .success:
                return selected
            case .failure:
                return !selected
            }
        } else {
            let result = storage.delete(id: comic.id, on: table)
            switch result {
            case .success:
                return selected
            case .failure:
                return !selected
            }
        }
    }
}
