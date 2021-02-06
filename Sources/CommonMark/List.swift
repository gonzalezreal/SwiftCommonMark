import cmark
import Foundation

/// A CommonMark list.
public struct List: Equatable {
    /// List style.
    public enum Style: Equatable {
        case bullet, ordered

        init(_ listType: cmark_list_type) {
            switch listType {
            case CMARK_ORDERED_LIST:
                self = .ordered
            default:
                self = .bullet
            }
        }
    }

    /// A single list item.
    public struct Item: Equatable {
        public let blocks: [Block]

        public init(blocks: [Block]) {
            self.blocks = blocks
        }

        init?(node: Node) {
            guard case CMARK_NODE_ITEM = node.type else { return nil }
            blocks = node.children.map(Block.init)
        }
    }

    /// The items in this list.
    public let items: [Item]

    /// The list style.
    public let style: Style

    /// The start index in an ordered list.
    public let start: Int

    /// Whether or not this list has tight or loose spacing between its items.
    public let isTight: Bool

    public init(items: [Item], style: Style, start: Int, isTight: Bool) {
        self.items = items
        self.style = style
        self.start = start
        self.isTight = isTight
    }

    init(node: Node) {
        assert(node.type == CMARK_NODE_LIST)

        items = node.children.compactMap(Item.init)
        style = Style(node.listType)
        start = node.listStart
        isTight = node.listTight
    }
}
