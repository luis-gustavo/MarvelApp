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
//    @available(iOS 13.0, *)
//    public func request(endPoint: EndPoint) -> AnyPublisher<NetworkResponse, NetworkError> {
//
//        guard let url = endPoint.url else {
//            return Fail(error: NetworkError.unableToCreateURL).eraseToAnyPublisher()
//        }
//
//        guard let request = endPoint.createRequest() else {
//            return Fail(error: NetworkError.queryParameters(url, [:])).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw NetworkError.notHTTPURLResponse
//                }
//
//                guard let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
//                    throw NetworkError.unknownStatusCode(httpResponse.statusCode)
//                }
//
//                return NetworkResponse(data: data, status: statusCode, response: httpResponse, request: request)
//            }
//            .mapError { ($0 as? NetworkError) ?? .unmapped($0) }
//            .eraseToAnyPublisher()
//    }
//
//    @available(iOS 13.0, *)
//    public func request(endPoint: EndPoint) async throws -> NetworkResponse {
//        guard let url = endPoint.url else {
//            throw NetworkError.unableToCreateURL
//        }
//
//        guard let request = endPoint.createRequest() else {
//            throw NetworkError.queryParameters(url, [:])
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.notHTTPURLResponse
//        }
//
//        guard let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
//            throw NetworkError.unknownStatusCode(httpResponse.statusCode)
//        }
//
//        return .init(
//            data: data,
//            status: statusCode,
//            response: httpResponse,
//            request: request
//        )
//    }

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
            ) else { completion(.failure(.unknownStatusCode(httpResponse.statusCode)))
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
