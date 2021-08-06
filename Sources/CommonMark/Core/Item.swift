import Foundation

/// A CommonMark list item.
public struct Item: Hashable {
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
}

#if swift(>=5.4)
    extension Item: ItemConvertible {
        public func asItems() -> [Item] {
            [self]
        }
    }
#endif

internal extension Item {
    var isMultiParagraph: Bool {
        blocks.filter(\.isParagraph).count > 1
    }
}
