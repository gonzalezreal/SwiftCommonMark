import cmark
import Foundation

extension Node {
    convenience init(blocks: [Block]) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_DOCUMENT)

        blocks.map(Node.init(block:)).forEach { node in
            cmark_node_append_child(cmark_node, node.cmark_node)
        }

        self.init(cmark_node)
    }

    convenience init(block: Block) {
        let cmark_node: OpaquePointer

        switch block {
        case let .blockQuote(children):
            cmark_node = cmark_node_new(CMARK_NODE_BLOCK_QUOTE)
            children.map(Node.init(block:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .list(list):
            cmark_node = Node(list: list).cmark_node
        case let .code(literal, language):
            cmark_node = cmark_node_new(CMARK_NODE_CODE_BLOCK)
            cmark_node_set_literal(cmark_node, literal)
            if !language.isEmpty {
                cmark_node_set_fence_info(cmark_node, language)
            }
        case let .html(literal):
            cmark_node = cmark_node_new(CMARK_NODE_HTML_BLOCK)
            cmark_node_set_literal(cmark_node, literal)
        case let .paragraph(children):
            cmark_node = cmark_node_new(CMARK_NODE_PARAGRAPH)
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .heading(children, level):
            cmark_node = cmark_node_new(CMARK_NODE_HEADING)
            cmark_node_set_heading_level(cmark_node, Int32(level))
            children.map(Node.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case .thematicBreak:
            cmark_node = cmark_node_new(CMARK_NODE_THEMATIC_BREAK)
        }

        self.init(cmark_node)
    }
}
