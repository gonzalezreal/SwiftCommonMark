import Foundation

/// A CommonMark list.
public struct List: Hashable {
    /// List style.
    public enum Style: Hashable {
        case bullet
        case ordered(start: Int)
    }

    /// List spacing.
    public enum Spacing {
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
        // Force loose spacing if any of the items contains more than one paragraph
        self.spacing = items.contains(where: \.isMultiParagraph) ? .loose : spacing
        self.items = items
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
