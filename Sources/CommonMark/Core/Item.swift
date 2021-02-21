import cmark
import Foundation

/// A CommonMark list item.
public struct Item: Equatable {
    public let blocks: [Block]

    public init(blocks: [Block]) {
        self.blocks = blocks
    }

    #if swift(>=5.4)
        public init(_ text: String) {
            self.init(blocks: text.asBlocks())
        }

        public init(@BlockBuilder content: () -> [Block]) {
            self.init(blocks: content())
        }
    #endif

    init?(node: Node) {
        guard case CMARK_NODE_ITEM = node.type else { return nil }
        self.init(blocks: node.children.map(Block.init))
    }

    /// Returns a new list item created by applying the specified transform to this item's text elements.
    public func applyingTransform(_ transform: (String) -> String) -> Item {
        Item(blocks: blocks.map { $0.applyingTransform(transform) })
    }
}

#if swift(>=5.4)
    extension Item: ItemConvertible {
        public func asItems() -> [Item] {
            [self]
        }
    }
#endif
