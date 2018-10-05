import Foundation
import XCTest
@testable import MinSwift

class EngineTests: XCTestCase {
    let engine = Engine()
    
    func testEvaluatePrint() {
        let output = try! engine.evaluate("print(42)")
        XCTAssertEqual(output, "42")
    }
}
