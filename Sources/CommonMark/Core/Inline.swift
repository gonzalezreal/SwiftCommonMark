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

    /// Returns a new inline created by applying the specified transform to this inline's text elements.
    public func applyingTransform(_ transform: (String) -> String) -> Inline {
        switch self {
        case let .text(text):
            return .text(transform(text))
        case let .emphasis(inlines):
            return .emphasis(inlines.map { $0.applyingTransform(transform) })
        case let .strong(inlines):
            return .strong(inlines.map { $0.applyingTransform(transform) })
        case let .link(inlines, url, title):
            return .link(
                inlines.map { $0.applyingTransform(transform) },
                url: url,
                title: title
            )
        case let .image(inlines, url, title):
            return .image(
                inlines.map { $0.applyingTransform(transform) },
                url: url,
                title: title
            )
        case .softBreak, .lineBreak, .code, .html:
            return self
        }
    }
}
