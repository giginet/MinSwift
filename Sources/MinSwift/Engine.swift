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
                case "print":
                    return arguments.first!
                default:
                    fatalError("Unexpected function call \(name)")
                }
            default:
                return nil
            }
        }
        return exports.compactMap { $0 }.joined(separator: "\n")
    }
}
