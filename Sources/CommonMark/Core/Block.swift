import cmark
import Foundation

/// A CommonMark document block.
public enum Block: Equatable {
    /// A block quote.
    case blockQuote([Block])

    /// A list.
    case list(List)

    /// A code block.
    case code(String, language: String = "")

    /// A group of lines that is treated as raw HTML.
    case html(String)

    /// A paragraph.
    case paragraph([Inline])

    /// A heading.
    case heading([Inline], level: Int)

    /// A thematic break.
    case thematicBreak

    init(node: Node) {
        switch node.type {
        case CMARK_NODE_BLOCK_QUOTE:
            self = .blockQuote(node.children.map(Block.init))
        case CMARK_NODE_LIST:
            self = .list(List(node: node))
        case CMARK_NODE_CODE_BLOCK:
            self = .code(node.literal!, language: node.fenceInfo ?? "")
        case CMARK_NODE_HTML_BLOCK:
            self = .html(node.literal!)
        case CMARK_NODE_PARAGRAPH:
            self = .paragraph(node.children.map(Inline.init))
        case CMARK_NODE_HEADING:
            self = .heading(
                node.children.map(Inline.init),
                level: node.headingLevel
            )
        case CMARK_NODE_THEMATIC_BREAK:
            self = .thematicBreak
        default:
            fatalError("Unhandled cmark node '\(node.typeString)'")
        }
    }

    /// Returns a new block created by applying the specified transform to this block's text elements.
    public func applyingTransform(_ transform: (String) -> String) -> Block {
        switch self {
        case let .blockQuote(blocks):
            return .blockQuote(blocks.map { $0.applyingTransform(transform) })
        case let .list(list):
            return .list(list.applyingTransform(transform))
        case let .paragraph(inlines):
            return .paragraph(inlines.map { $0.applyingTransform(transform) })
        case let .heading(inlines, level):
            return .heading(
                inlines.map { $0.applyingTransform(transform) },
                level: level
            )
        case .code, .html, .thematicBreak:
            return self
        }
    }
}
