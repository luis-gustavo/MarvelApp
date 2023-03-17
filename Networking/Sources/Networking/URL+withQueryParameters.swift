//
//  URL+withQueryParameters.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation

public extension URL {
    func with(queryParameters: [String: Any]) -> URL? {
        guard !queryParameters.isEmpty else { return self }
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryParameters.map { entry in
            URLQueryItem(name: entry.key, value: "\(entry.value)")
        }
        guard let urlWithQueryParamaters = urlComponents?.url else { return nil }
        return urlWithQueryParamaters
    }
}
