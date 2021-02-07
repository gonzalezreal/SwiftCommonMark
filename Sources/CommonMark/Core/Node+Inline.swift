import cmark
import Foundation

extension Node {
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
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .strong(children):
            cmark_node = cmark_node_new(CMARK_NODE_STRONG)
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .link(children, url, title):
            cmark_node = cmark_node_new(CMARK_NODE_LINK)
            cmark_node_set_url(cmark_node, url)
            if !title.isEmpty {
                cmark_node_set_title(cmark_node, title)
            }
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .image(children, url, title):
            cmark_node = cmark_node_new(CMARK_NODE_IMAGE)
            cmark_node_set_url(cmark_node, url)
            if !title.isEmpty {
                cmark_node_set_title(cmark_node, title)
            }
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        }

        self.init(cmark_node)
    }
}
