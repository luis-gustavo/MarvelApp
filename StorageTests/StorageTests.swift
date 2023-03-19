//
//  StorageTests.swift
//  StorageTests
//
//  Created by Luis Gustavo on 19/03/23.
//

import XCTest
import Service
@testable import Storage

final class StorageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Services.register(Storage.self) { SQLiteStorage(.inMemory) }
    }

    func testWritingIds() {
        // Given
        let storage: Storage = Services.make(for: Storage.self)
        let ids = [1, 2, 3]

        // When
        switch storage.write(ids: ids, on: .cart) {
        case let .success(response):
            // Then
            XCTAssertEqual(response, ids)
        case .failure:
            XCTFail()
        }
    }

    func testWritingAndReadingIds() {
        // Given
        let storage: Storage = Services.make(for: Storage.self)
        let ids = [1, 2, 3]

        // When
        switch storage.write(ids: ids, on: .cart) {
        case let .success(response):
            // Then
            XCTAssertEqual(response, ids)
            switch storage.read(from: .cart) {
            case let .success(rows):
                let writtenIds = rows.map { $0.model }
                XCTAssertEqual(ids, writtenIds)
            case .failure:
                XCTFail()
            }
        case .failure:
            XCTFail()
        }
    }

    func testWritingAndReadingAndDeletingIds() {
        // Given
        let storage: Storage = Services.make(for: Storage.self)
        let ids = [1, 2, 3]

        // When
        switch storage.write(ids: ids, on: .cart) {
        case let .success(response):
            // Then
            XCTAssertEqual(response, ids)
            switch storage.delete(id: 1, on: .cart) {
            case .success:
                switch storage.read(from: .cart) {
                case let .success(rows):
                    let writtenIds = rows.map { $0.model }
                    XCTAssertEqual([2, 3], writtenIds)
                case .failure:
                    XCTFail()
                }
            case .failure:
                XCTFail()
            }
        case .failure:
            XCTFail()
        }
    }
}
