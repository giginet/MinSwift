import Foundation
import XCTest
@testable import MinSwift

class ParserTests: XCTestCase {
    private let parser = Parser()

    func testLiteral() {
        let ast = parser.parse("42").first!
        if case let .literal(number) = ast {
            XCTAssertEqual(number, "42")
        } else {
            XCTFail()
        }
    }
}
