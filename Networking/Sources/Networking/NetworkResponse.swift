//
//  NetworkResponse.swift
//  
//
//  Created by Luis Gustavo on 16/03/23.
//

import Foundation

public struct NetworkResponse: Hashable {

    // MARK: - Properties
    public let data: Data
    public let status: HTTPStatusCode
    public let response: HTTPURLResponse
    public let request: URLRequest

    // MARK: - Inits
    public init(data: Data, status: HTTPStatusCode, response: HTTPURLResponse, request: URLRequest) {
        self.data = data
        self.status = status
        self.response = response
        self.request = request
    }
}
