//
//  URLSessionNetworkingProtocol.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Combine
import Foundation

public protocol URLSessionNetworkingProtocol {
//    @available(iOS 13.0, *)
//    func request(endPoint: EndPoint) -> AnyPublisher<NetworkResponse, NetworkError>
//
//    @available(iOS 13.0, *)
//    func request(endPoint: EndPoint) async throws -> NetworkResponse

    func request(endPoint: EndPoint, _ completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void)
}
