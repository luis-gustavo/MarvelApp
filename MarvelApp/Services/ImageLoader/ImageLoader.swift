//
//  ImageLoader.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 17/03/23.
//

import Foundation

final class ImageLoader: ImageLoaderProtocol {

    // MARK: - Properties
    static let shared = ImageLoader()
    private var imageCache = NSCache<NSString, NSData>()

    // MARK: - Init
    private init() { }

    // MARK: - ImageLoaderProtocol
    func downloadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let key = url.absoluteString as NSString
            let value = data as NSData
            self?.imageCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
