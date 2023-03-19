//
//  StorageError.swift
//  Storage
//
//  Created by Luis Gustavo on 18/03/23.
//

import Foundation

public enum StorageError: Error, CustomStringConvertible {
    case connectionCreation(Error)
    case tableCreation(Error)
    case insertion(Error)
    case selection(Error)
    case unknown(Error)

    public var description: String {
        switch self {
        case .connectionCreation(let error): return "Connection creation: \(error)"
        case .tableCreation(let error): return "Table creation: \(error)"
        case .insertion(let error): return "Insertion: \(error)"
        case .selection(let error): return "Selection: \(error)"
        case .unknown(let error): return "Unknown: \(error)"
        }
    }
}
