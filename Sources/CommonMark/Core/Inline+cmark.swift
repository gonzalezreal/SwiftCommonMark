import cmark
import Foundation

public extension Inline {
    func renderCommonMark() -> String {
        let node = CommonMarkNode(inline: self)
        return String(cString: cmark_render_commonmark(node.cmark_node, CMARK_OPT_DEFAULT, 0))
    }

    func renderHTML(options: Document.RenderingOptions = .init()) -> String {
        let node = CommonMarkNode(inline: self)
        return String(cString: cmark_render_html(node.cmark_node, options.rawValue))
    }
}

internal extension Inline {
    init?(commonMarkNode: CommonMarkNode) {
        switch commonMarkNode.type {
        case CMARK_NODE_TEXT:
            self = .text(commonMarkNode.literal ?? "")
        case CMARK_NODE_SOFTBREAK:
            self = .softBreak
        case CMARK_NODE_LINEBREAK:
            self = .lineBreak
        case CMARK_NODE_CODE:
            self = .code(commonMarkNode.literal!)
        case CMARK_NODE_HTML_INLINE:
            self = .html(commonMarkNode.literal!)
        case CMARK_NODE_EMPH:
            self = .emphasis(children: commonMarkNode.children.compactMap(Inline.init))
        case CMARK_NODE_STRONG:
            self = .strong(children: commonMarkNode.children.compactMap(Inline.init))
        case CMARK_NODE_LINK:
            self = .link(
                children: commonMarkNode.children.compactMap(Inline.init),
                url: commonMarkNode.url.flatMap(URL.init(string:)),
                title: commonMarkNode.title?.isEmpty ?? true ? nil : commonMarkNode.title
            )
        case CMARK_NODE_IMAGE:
            self = .image(
                children: commonMarkNode.children.compactMap(Inline.init),
                url: commonMarkNode.url.flatMap(URL.init(string:)),
                title: commonMarkNode.title?.isEmpty ?? true ? nil : commonMarkNode.title
            )
        default:
            assertionFailure("Unknown inline type '\(commonMarkNode.typeString)'")
            return nil
        }
    }
}

internal extension CommonMarkNode {
    convenience init(inline: Inline) {
        let cmark_node: OpaquePointer

        switch inline {
        case let .text(literal):
            cmark_node = cmark_node_new(CMARK_NODE_TEXT)
            cmark_node_set_literal(cmark_node, literal)
        case .softBreak:
            cmark_node = cmark_node_new(CMARK_NODE_SOFTBREAK)
        case .lineBreak:
            cmark_node = cmark_node_new(CMARK_NODE_LINEBREAK)
        case let .code(literal):
            cmark_node = cmark_node_new(CMARK_NODE_CODE)
            cmark_node_set_literal(cmark_node, literal)
        case let .html(literal):
            cmark_node = cmark_node_new(CMARK_NODE_HTML_INLINE)
            cmark_node_set_literal(cmark_node, literal)
        case let .emphasis(children):
            cmark_node = cmark_node_new(CMARK_NODE_EMPH)
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .strong(children):
            cmark_node = cmark_node_new(CMARK_NODE_STRONG)
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .link(children, url, title):
            cmark_node = cmark_node_new(CMARK_NODE_LINK)
            if let url = url {
                cmark_node_set_url(cmark_node, url.absoluteString)
            }
            if let title = title {
                cmark_node_set_title(cmark_node, title)
            }
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .image(children, url, title):
            cmark_node = cmark_node_new(CMARK_NODE_IMAGE)
            if let url = url {
                cmark_node_set_url(cmark_node, url.absoluteString)
            }
            if let title = title {
                cmark_node_set_title(cmark_node, title)
            }
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        }

        self.init(cmark_node)
    }
}
