import Foundation
import SourceKittenFramework

internal indirect enum SyntaxTree {
    case funcutionCall(String, [SyntaxTree])
    case literal(String)
    case addition(SyntaxTree, SyntaxTree)
    case subtraction(SyntaxTree, SyntaxTree)
}

internal struct ParseResult {
}

internal struct Parser {
    init() { }

    func parse(_ contents: String) -> [SyntaxTree] {
        let statements = contents.split(separator: "\n")
        let structure = try! Structure(file: File(contents: contents))
        return statements.map { parseLine(String($0)) }
    }

    private func parseLine(_ line: String) -> SyntaxTree {
        return .literal(line)
    }
}
