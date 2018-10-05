import Foundation
import SourceKittenFramework

internal indirect enum SyntaxTree {
    case funcutionCall(String, [SyntaxTree])
    case literal(String)
    case addition(SyntaxTree, SyntaxTree)
    case subtraction(SyntaxTree, SyntaxTree)
}

internal struct Substructure: Codable {
    enum Kind: String, Codable {
        case variable = "source.lang.swift.decl.var.global"
        case call = "source.lang.swift.expr.call"
        case function = "source.lang.swift.decl.function.free"
        case parameter = "source.lang.swift.decl.var.parameter"
    }
    
    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case substructures = "key.substructure"
    }
    
    let kind: Kind
    let name: String
    let substructures: [Substructure]?
}

internal struct ParseResult {
}

internal struct Parser {
    init() { }

    func parse(_ contents: String) throws -> [SyntaxTree] {
        let substructures = try parseSubstructures(contents)
        let tree = substructures.map { substructure -> SyntaxTree in
            switch substructure.kind {
            case .function:
                break
            case .call:
                break
            case .parameter:
                break
            case .variable:
                break
            }
            return .literal("42")
        }
        return tree
    }
    
    func parseSubstructures(_ contents: String) throws -> [Substructure] {
        let structure = try Structure(file: File(contents: contents))
        let data = try JSONSerialization.data(withJSONObject: structure.dictionary["key.substructure"]!, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode([Substructure].self, from: data)
    }

    private func parseLine(_ line: String) -> SyntaxTree {
        return .literal(line)
    }
}

public protocol LiteralType {
    static func parse(from string: String) -> Self
}

extension Int: LiteralType {
    public static func parse(from string: String) -> Int {
        return Int(string)!
    }
}

internal struct LiteralParser {
    func parse<Literal: LiteralType>(from literalString: String) -> Literal? {
        let digitRegexp = try! NSRegularExpression(pattern: "^[0-9]+$", options: [])
        let matches = digitRegexp.matches(in: literalString, options: [], range: NSRange(location: 0, length: literalString.utf16.count))
        if !matches.isEmpty {
            return Literal.parse(from: literalString)
        }
        return nil
    }
}
