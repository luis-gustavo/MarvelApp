//
//  URLSessionNetworkingProtocol.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Combine
import Foundation

public protocol URLSessionNetworkingProtocol {
    func request(endPoint: EndPoint, _ completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void)
}
