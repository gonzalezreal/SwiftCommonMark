import cmark
import Foundation

public extension Item {
    func renderCommonMark() -> String {
        let node = CommonMarkNode(item: self)
        return String(cString: cmark_render_commonmark(node.cmark_node, CMARK_OPT_DEFAULT, 0))
    }

    func renderHTML(options: Document.RenderingOptions = .init()) -> String {
        let node = CommonMarkNode(item: self)
        return String(cString: cmark_render_html(node.cmark_node, options.rawValue))
    }
}

internal extension Item {
    init?(commonMarkNode: CommonMarkNode) {
        guard case CMARK_NODE_ITEM = commonMarkNode.type else {
            assertionFailure("Expecting 'CMARK_NODE_ITEM' but instead got '\(commonMarkNode.typeString)'")
            return nil
        }
        self.init(blocks: commonMarkNode.children.compactMap(Block.init))
    }
}

internal extension CommonMarkNode {
    convenience init(item: Item) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_ITEM)
        item.blocks.map(CommonMarkNode.init(block:)).forEach { childNode in
            cmark_node_append_child(cmark_node, childNode.cmark_node)
        }

        self.init(cmark_node)
    }
}
