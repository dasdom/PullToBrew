import XCTest
@testable import PullToBrew

final class PullToBrewTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PullToBrew().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
