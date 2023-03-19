//
//  SQLiteStorage.swift
//  Storage
//
//  Created by Luis Gustavo on 18/03/23.
//

import SQLite

public final class SQLiteStorage: Storage {

    // MARK: - Properties
    private let connection: Swift.Result<Connection, StorageError>

    // MARK: - Inits
    public init(_ location: Connection.Location) {
        let connectionResult = createConnection(location)
        switch connectionResult {
        case let .success(connection):
            let schemaResult = createSchema(at: connection)
            switch schemaResult {
            case let .success(connection):
                self.connection = .success(connection)
            case let .failure(storageError):
                self.connection = .failure(storageError)
            }
        case let .failure(storageError):
            self.connection = .failure(storageError)
        }
    }

    // MARK: - Storage
    public func write(ids: [Int], on table: StorageTable) -> Swift.Result<[Int], StorageError> {
        switch connection {
        case let .success(database):
            do {
                try ids.forEach { id in
                    switch table {
                    case .cart:
                        try database.run(cartTable.insert(
                            or: .replace,
                            comicIdExpression <- id,
                            updatedAtExpression <- Date()
                        ))
                    case .favorite:
                        try database.run(favoritesTable.insert(
                            or: .replace,
                            comicIdExpression <- id,
                            updatedAtExpression <- Date()
                        ))
                    }
                }
                return .success(ids)
            } catch {
                return .failure(.unknown(error))
            }
        case let .failure(error):
            return .failure(error)
        }
    }

    public func delete(id: Int, on table: StorageTable) -> Swift.Result<Int, StorageError> {
        switch connection {
        case let .success(database):
            do {
                switch table {
                case .cart:
                    let current = cartTable.filter(comicIdExpression == id)
                    try database.run(current.delete())
                case .favorite:
                    let current = favoritesTable.filter(comicIdExpression == id)
                    try database.run(current.delete())
                }
                return .success(id)
            } catch {
                return .failure(.unknown(error))
            }
        case let .failure(error):
            return .failure(error)
        }
    }

    public func read(from table: StorageTable) -> Swift.Result<[Row<Int>], StorageError> {
        switch connection {
        case let .success(database):
            switch table {
            case .cart:
                do {
                    let rows =  try database.prepare(cartTable).map { row -> Row<Int> in
                        let result = Row<Int>(model: row[comicIdExpression], updatedAt: row[updatedAtExpression])
                        return result
                    }
                    return .success(rows)
                } catch {
                    return .failure(.unknown(error))
                }
            case .favorite:
                do {
                    let rows =  try database.prepare(favoritesTable).map { row -> Row<Int> in
                        let result = Row<Int>(model: row[comicIdExpression], updatedAt: row[updatedAtExpression])
                        return result
                    }
                    return .success(rows)
                } catch {
                    return .failure(.unknown(error))
                }
            }
        case let .failure(error):
            return .failure(error)
        }
    }
}

private let favoritesTable = Table(StorageTable.favorite.rawValue)
private let cartTable = Table(StorageTable.cart.rawValue)
private let comicIdExpression = Expression<Int>("comic_id")
private let updatedAtExpression = Expression<Date>("updated_at")

private func createSchema(at connection: Connection) -> Swift.Result<Connection, StorageError> {

    do {
        try connection.run(favoritesTable.create(ifNotExists: true) { builder in
            builder.column(comicIdExpression, primaryKey: true)
            builder.column(updatedAtExpression)
        })

        try connection.run(cartTable.create(ifNotExists: true) { builder in
            builder.column(comicIdExpression, primaryKey: true)
            builder.column(updatedAtExpression)
        })
    } catch {
        return .failure(StorageError.tableCreation(error))
    }

    return .success(connection)
}

private func createConnection(_ location: Connection.Location) -> Swift.Result<Connection, StorageError> {
    do {
        let connection = try Connection(location)
        return .success(connection)
    } catch {
        return .failure(StorageError.connectionCreation(error))
    }
}

enum MyError: Error {
    case meuErro
}
