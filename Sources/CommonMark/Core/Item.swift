import cmark
import Foundation

/// A CommonMark list item.
public struct Item: Equatable {
    public let blocks: [Block]

    public init(blocks: [Block]) {
        self.blocks = blocks
    }

    public init(_ text: String) {
        self.init(blocks: text.asBlocks())
    }

    public init(@BlockBuilder content: () -> [Block]) {
        self.init(blocks: content())
    }

    init?(node: Node) {
        guard case CMARK_NODE_ITEM = node.type else { return nil }
        self.init(blocks: node.children.map(Block.init))
    }
}

extension Item: ItemConvertible {
    public func asItems() -> [Item] {
        [self]
    }
}
