//
//  ImageLoaderProtocol.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

protocol ImageLoaderProtocol {
    func downloadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void)
}
