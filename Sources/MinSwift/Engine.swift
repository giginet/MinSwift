import Foundation

public struct Engine {
    public init() { }

    public func evaluate(_ contents: String) throws -> String {
        let parser = Parser()
        let trees = try parser.parse(contents)
        let exports: [String?] = trees.map { tree -> String? in
            switch tree {
            case .funcutionCall(let name, let arguments):
                switch name {
                case .print:
                    return expandVariable(arguments.first!)
                }
            default:
                return nil
            }
        }
        return exports.compactMap { $0 }.joined(separator: "\n")
    }
    
    func expandVariable<T>(_ literal: Literal) -> T? {
        switch literal {
        case .string(let string):
            return string as? T
        case .integer(let int):
            return int as? T
        default:
            fatalError("Not implemented")
        }
    }
}
