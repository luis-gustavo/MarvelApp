//
//  ImageLoaderTests.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 19/03/23.
//

import XCTest
@testable import MarvelApp

final class ImageLoaderTests: XCTestCase {

    func testImageLoader() {

        // Given
        let url = Bundle(for: ImageLoaderTests.self).url(forResource: "logo", withExtension: "png")!
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Failed to read contents of \(url)")
            return
        }
        let expectation = self.expectation(description: "Image")

        // When
        ImageLoader.shared.downloadImage(url) { result in
            switch result {
            case let .success(imageData):
                // Then
                XCTAssertEqual(data, imageData)
                expectation.fulfill()
            case .failure:
                XCTFail("Failed to download image")
            }
        }

        wait(for: [expectation], timeout: 1)
    }
}
