import cmark
import Foundation

/// A CommonMark list.
public struct List: Equatable {
    /// List style.
    public enum Style: Equatable {
        case bullet
        case ordered(start: Int)

        init(_ listType: cmark_list_type, _ listStart: Int) {
            switch listType {
            case CMARK_ORDERED_LIST:
                self = .ordered(start: listStart)
            default:
                self = .bullet
            }
        }
    }

    /// List spacing.
    public enum Spacing: Equatable {
        case loose, tight
    }

    /// The list style.
    public let style: Style

    /// Whether or not this list has tight or loose spacing between its items.
    public let spacing: Spacing

    /// The items in this list.
    public let items: [Item]

    public init(style: Style = .bullet, spacing: Spacing = .tight, items: [Item]) {
        self.style = style
        self.spacing = spacing
        self.items = items
    }

    init(node: Node) {
        assert(node.type == CMARK_NODE_LIST)

        self.init(
            style: Style(node.listType, node.listStart),
            spacing: node.listTight ? .tight : .loose,
            items: node.children.compactMap(Item.init)
        )
    }

    /// Returns a new list created by applying the specified transform to this list's text elements.
    public func applyingTransform(_ transform: (String) -> String) -> List {
        List(
            style: style,
            spacing: spacing,
            items: items.map { $0.applyingTransform(transform) }
        )
    }
}

#if swift(>=5.4)
    public extension List {
        init(spacing: Spacing = .tight, @ItemBuilder content: () -> [Item]) {
            self.init(style: .bullet, spacing: spacing, items: content())
        }

        init(start: Int, spacing: Spacing = .tight, @ItemBuilder content: () -> [Item]) {
            self.init(style: .ordered(start: start), spacing: spacing, items: content())
        }
    }

    extension List: BlockConvertible {
        public func asBlocks() -> [Block] {
            [.list(self)]
        }
    }
#endif
