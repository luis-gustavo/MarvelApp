//
//  ComicListRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import UIKit

protocol ComicListRouterProtocol {
    var navigationViewController: UINavigationController? { get set }
    func showComicDetail(comic: Comic)
}
