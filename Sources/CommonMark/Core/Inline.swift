import cmark
import Foundation

/// A CommonMark document inline.
public enum Inline: Equatable {
    /// Plain textual content.
    case text(String)

    /// Soft line break.
    case softBreak

    /// Hard line break.
    case lineBreak

    /// Code span.
    case code(String)

    /// Raw HTML.
    case html(String)

    /// Emphasis.
    case emphasis([Inline])

    /// Strong emphasis.
    case strong([Inline])

    /// Link.
    case link([Inline], url: String, title: String = "")

    /// Image.
    case image([Inline], url: String, title: String = "")

    init(node: Node) {
        switch node.type {
        case CMARK_NODE_TEXT:
            self = .text(node.literal!)
        case CMARK_NODE_SOFTBREAK:
            self = .softBreak
        case CMARK_NODE_LINEBREAK:
            self = .lineBreak
        case CMARK_NODE_CODE:
            self = .code(node.literal!)
        case CMARK_NODE_HTML_INLINE:
            self = .html(node.literal!)
        case CMARK_NODE_EMPH:
            self = .emphasis(node.children.map(Inline.init))
        case CMARK_NODE_STRONG:
            self = .strong(node.children.map(Inline.init))
        case CMARK_NODE_LINK:
            self = .link(node.children.map(Inline.init), url: node.url!, title: node.title ?? "")
        case CMARK_NODE_IMAGE:
            self = .image(node.children.map(Inline.init), url: node.url!, title: node.title ?? "")
        default:
            fatalError("Unhandled cmark node '\(node.typeString)'")
        }
    }
}
