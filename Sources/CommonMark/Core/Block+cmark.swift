import cmark
import Foundation

public extension Block {
    func renderCommonMark() -> String {
        let node = CommonMarkNode(block: self)
        return String(cString: cmark_render_commonmark(node.cmark_node, CMARK_OPT_DEFAULT, 0))
    }

    func renderHTML(options: Document.RenderingOptions = .init()) -> String {
        let node = CommonMarkNode(block: self)
        return String(cString: cmark_render_html(node.cmark_node, options.rawValue))
    }
}

internal extension Block {
    init?(commonMarkNode: CommonMarkNode) {
        switch commonMarkNode.type {
        case CMARK_NODE_BLOCK_QUOTE:
            self = .blockQuote(commonMarkNode.children.compactMap(Block.init))
        case CMARK_NODE_LIST:
            self = .list(List(commonMarkNode: commonMarkNode)!)
        case CMARK_NODE_CODE_BLOCK:
            self = .code(commonMarkNode.literal ?? "", language: commonMarkNode.fenceInfo ?? "")
        case CMARK_NODE_HTML_BLOCK:
            self = .html(commonMarkNode.literal ?? "")
        case CMARK_NODE_PARAGRAPH:
            self = .paragraph(commonMarkNode.children.compactMap(Inline.init))
        case CMARK_NODE_HEADING:
            self = .heading(commonMarkNode.children.compactMap(Inline.init), level: commonMarkNode.headingLevel)
        case CMARK_NODE_THEMATIC_BREAK:
            self = .thematicBreak
        default:
            assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
            return nil
        }
    }
}

internal extension CommonMarkNode {
    convenience init(block: Block) {
        let cmark_node: OpaquePointer

        switch block {
        case let .blockQuote(children):
            cmark_node = cmark_node_new(CMARK_NODE_BLOCK_QUOTE)
            children.map(CommonMarkNode.init(block:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .list(list):
            cmark_node = CommonMarkNode(list: list).cmark_node
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
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .heading(children, level):
            cmark_node = cmark_node_new(CMARK_NODE_HEADING)
            cmark_node_set_heading_level(cmark_node, Int32(level))
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case .thematicBreak:
            cmark_node = cmark_node_new(CMARK_NODE_THEMATIC_BREAK)
        }

        self.init(cmark_node)
    }
}
