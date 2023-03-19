import XCTest
@testable import Service

final class ServiceTests: XCTestCase {

    private let services = Services.default

    func testCreatingService() throws {

        // Given
        services.register(MockService.self) { MockService.one }

        // When
        let retrievedService: MockService = services.make(for: MockService.self)

        // Then
        XCTAssert(retrievedService == MockService.one)
    }

    func testComparingDifferentServices() throws {

        // Given
        services.register(MockService.self) { MockService.one }

        // When
        let retrievedService: MockService = services.make(for: MockService.self)

        // Then
        XCTAssert(retrievedService != MockService.two)
    }
}

private enum MockService {
    case one, two
}
