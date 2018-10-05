import Foundation
import XCTest
@testable import MinSwift

class ParserTests: XCTestCase {
    private let parser = Parser()
    
    func testParseStructures() {
        let contents =
        """
40 + 2
let a = 42
print(1 + 1)
func fizzbuzz(n: int) -> string {
    return "fizzbuzz"
}
print(fizzbuzz())
print(a)
"""
        let substructures = try! parser.parse(contents)
        print(substructures)
    }
    
    func testExpandArguments() {
        let contents =
        """
print(100, 200)
"""
        let substructures = try! parser.parseSubstructures(contents)
        let arguments = parser.expandArgument(from: substructures.first!, contents: contents)
        XCTAssertEqual(arguments, ["100", "200"])
    }
}
