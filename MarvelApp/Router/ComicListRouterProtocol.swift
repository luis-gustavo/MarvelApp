//
//  ComicListRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol ComicListRouterProtocol {
    var comicListNavigationViewController: UINavigationController? { get set }
    func showComicDetail(_ sender: ComicListRouterProtocol, comic: Comic)
    func showSearch()
}
