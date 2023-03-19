//
//  Storage.swift
//  Storage
//
//  Created by Luis Gustavo on 18/03/23.
//

import Foundation

public enum StorageTable: String {
    case favorite, cart
}

public protocol Storage {
    func write(ids: [Int], on table: StorageTable) -> Swift.Result<[Int], StorageError>
    func read(from table: StorageTable) -> Swift.Result<[Row<Int>], StorageError>
    func delete(id: Int, on table: StorageTable) -> Swift.Result<Int, StorageError>
}

public struct Row<Model> {
    public let model: Model
    public let updatedAt: Date

    public init(model: Model, updatedAt: Date) {
        self.model = model
        self.updatedAt = updatedAt
    }
}
