//
//  URLSessionNetworking.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Combine
import Foundation

public struct URLSessionNetworking: URLSessionNetworkingProtocol {

    // MARK: - Properties
    public static let shared = URLSessionNetworking()

    // MARK: - Init
    private init() { }

    // MARK: - NetworkLayerProtocol
    public func request(endPoint: EndPoint, _ completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {

        guard let url = endPoint.url else {
            completion(.failure(NetworkError.unableToCreateURL))
            return
        }

        guard let request = endPoint.createRequest() else {
            completion(.failure(NetworkError.queryParameters(url, [:])))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unmapped(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.notHTTPURLResponse))
                return
            }

            guard let statusCode = HTTPStatusCode(
                rawValue: httpResponse.statusCode
            ) else {
                completion(.failure(.unknownStatusCode(httpResponse.statusCode)))
                return
            }

            completion(.success(.init(
                data: data ?? Data(),
                status: statusCode,
                response: httpResponse,
                request: request
            )))
        }
        dataTask.resume()
    }
}
