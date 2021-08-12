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
            self = .blockQuote(items: commonMarkNode.children.compactMap(Block.init))
        case CMARK_NODE_LIST:
            self = .list(
                items: commonMarkNode.children.compactMap(Array.init(commonMarkNode:)),
                type: ListType(commonMarkNode.listType, commonMarkNode.listStart),
                tight: commonMarkNode.listTight
            )
        case CMARK_NODE_CODE_BLOCK:
            self = .code(text: commonMarkNode.literal ?? "", info: commonMarkNode.fenceInfo)
        case CMARK_NODE_HTML_BLOCK:
            self = .html(text: commonMarkNode.literal ?? "")
        case CMARK_NODE_PARAGRAPH:
            self = .paragraph(text: commonMarkNode.children.compactMap(Inline.init))
        case CMARK_NODE_HEADING:
            self = .heading(text: commonMarkNode.children.compactMap(Inline.init), level: commonMarkNode.headingLevel)
        case CMARK_NODE_THEMATIC_BREAK:
            self = .thematicBreak
        default:
            assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
            return nil
        }
    }
}

private extension ListType {
    init(_ cmark_list_type: cmark_list_type, _ start: Int) {
        switch cmark_list_type {
        case CMARK_ORDERED_LIST:
            self = .ordered(start: start)
        default:
            self = .bullet
        }
    }
}

private extension Array where Element == Block {
    init?(commonMarkNode: CommonMarkNode) {
        guard case CMARK_NODE_ITEM = commonMarkNode.type else {
            assertionFailure("Expecting 'CMARK_NODE_ITEM' but instead got '\(commonMarkNode.typeString)'")
            return nil
        }
        self.init(commonMarkNode.children.compactMap(Block.init))
    }
}

internal extension CommonMarkNode {
    convenience init(block: Block) {
        let cmark_node: OpaquePointer

        switch block {
        case let .blockQuote(items):
            cmark_node = cmark_node_new(CMARK_NODE_BLOCK_QUOTE)
            items.map(CommonMarkNode.init(block:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .list(items, type, tight):
            cmark_node = cmark_node_new(CMARK_NODE_LIST)
            switch type {
            case .bullet:
                cmark_node_set_list_type(cmark_node, CMARK_BULLET_LIST)
            case let .ordered(start):
                cmark_node_set_list_type(cmark_node, CMARK_ORDERED_LIST)
                cmark_node_set_list_start(cmark_node, Int32(start))
            }
            cmark_node_set_list_tight(cmark_node, tight ? 1 : 0)
            items.map(CommonMarkNode.init(item:)).forEach { childNode in
                cmark_node_append_child(cmark_node, childNode.cmark_node)
            }
        case let .code(text, info):
            cmark_node = cmark_node_new(CMARK_NODE_CODE_BLOCK)
            cmark_node_set_literal(cmark_node, text)
            if let info = info, !info.isEmpty {
                cmark_node_set_fence_info(cmark_node, info)
            }
        case let .html(text):
            cmark_node = cmark_node_new(CMARK_NODE_HTML_BLOCK)
            cmark_node_set_literal(cmark_node, text)
        case let .paragraph(children):
            cmark_node = cmark_node_new(CMARK_NODE_PARAGRAPH)
            children.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case let .heading(text, level):
            cmark_node = cmark_node_new(CMARK_NODE_HEADING)
            cmark_node_set_heading_level(cmark_node, Int32(level))
            text.map(CommonMarkNode.init(inline:)).forEach { node in
                cmark_node_append_child(cmark_node, node.cmark_node)
            }
        case .thematicBreak:
            cmark_node = cmark_node_new(CMARK_NODE_THEMATIC_BREAK)
        }

        self.init(cmark_node)
    }
}

private extension CommonMarkNode {
    convenience init(item: [Block]) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_ITEM)
        item.map(CommonMarkNode.init(block:)).forEach { childNode in
            cmark_node_append_child(cmark_node, childNode.cmark_node)
        }

        self.init(cmark_node)
    }
}
