//
//  ComicDetailViewModel.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

final class ComicDetailViewModel {

    // MARK: - Properties
    var title: String { comic.title }
    var imageUrl: URL? { comic.thumbnail.url }
    var price: String { comic.prices.map { "\($0.typeTitle): $\($0.price)" }.joined(separator: "\n") }
    var issue: String { "Issue #\(comic.issueNumber)" }
    private let comic: Comic

    // MARK: - Inits
    init(comic: Comic) {
        self.comic = comic
    }
}
