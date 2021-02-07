import cmark
import Foundation

extension Node {
    convenience init(item: Item) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_ITEM)
        item.blocks.map(Node.init(block:)).forEach { node in
            cmark_node_append_child(cmark_node, node.cmark_node)
        }

        self.init(cmark_node)
    }
}
