import XCTest
@testable import WTV

final class WTVTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WTV().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
