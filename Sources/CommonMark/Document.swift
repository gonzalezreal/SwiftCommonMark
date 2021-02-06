import cmark
import Foundation

/// A CommonMark document.
public struct Document {
    /// The blocks that form this document.
    public var blocks: [Block] {
        node.children.map(Block.init)
    }

    /// A set with all the image locations contained in this document.
    public var imageURLs: Set<URL> {
        Set(node.imageURLs)
    }

    private let node: Node

    public init(_ content: String) {
        node = Node(content)!
    }

    public init(contentsOfFile path: String) throws {
        try self.init(String(contentsOfFile: path))
    }

    public init(contentsOfFile path: String, encoding: String.Encoding) throws {
        try self.init(String(contentsOfFile: path, encoding: encoding))
    }
}

extension Document: Equatable {
    public static func == (lhs: Document, rhs: Document) -> Bool {
        if lhs.node === rhs.node {
            return true
        } else {
            return lhs.node.description == rhs.node.description
        }
    }
}

extension Document: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(node.description)
    }
}

extension Document: CustomStringConvertible {
    public var description: String {
        node.description
    }
}

extension Document: ExpressibleByStringInterpolation {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension Document: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let content = try container.decode(String.self)

        guard let node = Node(content) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid document: \(content)"
            )
        }

        self.node = node
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
