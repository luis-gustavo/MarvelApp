//
//  EndPoint.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation

public protocol EndPoint {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var body: Data? { get }
    func createRequest() -> URLRequest?
}

public extension EndPoint {
    func createRequest() -> URLRequest? {
        guard let url = url else { return nil }
        guard let urlWithQueryParamaters = url.with(queryParameters: queryParameters) else { return nil }
        var request = URLRequest(url: urlWithQueryParamaters)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
