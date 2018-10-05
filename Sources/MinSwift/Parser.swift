import Foundation

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

    func parse(_ string: String) -> [SyntaxTree] {
        let statements = string.split(separator: "\n")
        return statements.map { parseLine(String($0)) }
    }

    private func parseLine(_ line: String) -> SyntaxTree {
        return .literal(line)
    }
}
