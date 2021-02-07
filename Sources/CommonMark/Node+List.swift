import cmark
import Foundation

extension Node {
    convenience init(list: List) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_LIST)

        switch list.style {
        case .bullet:
            cmark_node_set_list_type(cmark_node, CMARK_BULLET_LIST)
        case let .ordered(start):
            cmark_node_set_list_type(cmark_node, CMARK_ORDERED_LIST)
            cmark_node_set_list_start(cmark_node, Int32(start))
        }

        switch list.spacing {
        case .loose:
            cmark_node_set_list_tight(cmark_node, 0)
        case .tight:
            if list.isMultiParagraph {
                cmark_node_set_list_tight(cmark_node, 0)
            } else {
                cmark_node_set_list_tight(cmark_node, 1)
            }
        }

        list.items.map(Node.init(item:)).forEach { node in
            cmark_node_append_child(cmark_node, node.cmark_node)
        }

        self.init(cmark_node)
    }
}

private extension List {
    var isMultiParagraph: Bool {
        for item in items {
            if item.blocks.filter(\.isParagraph).count > 1 {
                return true
            }
        }
        return false
    }
}

private extension Block {
    var isParagraph: Bool {
        guard case .paragraph = self else { return false }
        return true
    }
}
