//
//  ComicDetailRouterProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 19/03/23.
//

import UIKit

protocol ComicDetailRouterProtocol {
    var comicDetailContext: UIViewController? { get set }
    func showCheckout(sender: ComicDetailRouterProtocol, comics: [Comic])
}
