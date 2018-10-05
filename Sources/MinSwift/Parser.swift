import Foundation
import SourceKittenFramework

internal indirect enum SyntaxTree {
    case funcutionCall(BuiltinFunction, [String])
    case literal(String)
    case addition(SyntaxTree, SyntaxTree)
    case subtraction(SyntaxTree, SyntaxTree)
}

internal struct Substructure: Codable {
    enum Kind: String, Codable, Equatable {
        case variable = "source.lang.swift.decl.var.global"
        case call = "source.lang.swift.expr.call"
        case function = "source.lang.swift.decl.function.free"
        case parameter = "source.lang.swift.decl.var.parameter"
        case argument = "source.lang.swift.expr.argument"
    }
    
    enum CodingKeys: String, CodingKey {
        case kind = "key.kind"
        case name = "key.name"
        case substructures = "key.substructure"
        case bodyLength = "key.bodylength"
        case bodyOffset = "key.bodyoffset"
    }
    
    let kind: Kind
    let name: String?
    let substructures: [Substructure]?
    let bodyLength: Int?
    let bodyOffset: Int?
}

internal struct Parser {
    init() { }

    func parse(_ contents: String) throws -> [SyntaxTree] {
        let substructures = try parseSubstructures(contents)
        let tree = substructures.map { substructure -> SyntaxTree? in
            switch substructure.kind {
            case .function:
                break
            case .call:
                let arguments = expandArgument(from: substructure, contents: contents)
                guard let functionName = substructure.name, let function = BuiltinFunction(rawValue: functionName) else {
                    fatalError("function \(substructure.name!) is not defined.")
                }
                return .funcutionCall(function, arguments)
            case .parameter:
                break
            case .variable:
                break
            case .argument:
                break
            }
            return nil
            }.compactMap { $0 }
        return tree
    }
    
    func parseSubstructures(_ contents: String) throws -> [Substructure] {
        let structure = try Structure(file: File(contents: contents))
        let data = try JSONSerialization.data(withJSONObject: structure.dictionary["key.substructure"]!, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode([Substructure].self, from: data)
    }
    
    func expandArgument(from substructure: Substructure, contents: String) -> [String] {
        if substructure.kind != .call {
            fatalError("kind must be call")
        }
//        return substructure.substructures?.compactMap { argument in
//            if argument.kind == .argument {
//                let from = contents.index(contents.startIndex, offsetBy: argument.bodyOffset!)
//                let to = contents.index(from, offsetBy: argument.bodyLength!)
//                return String(contents[from..<to])
//            }
//            return nil
//            } ?? []
        let from = contents.index(contents.startIndex, offsetBy: substructure.bodyOffset!)
        let to = contents.index(from, offsetBy: substructure.bodyLength!)
        return contents[from..<to].split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
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
