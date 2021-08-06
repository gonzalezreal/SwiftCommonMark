import cmark
import Foundation

public extension List {
    func renderCommonMark() -> String {
        let node = CommonMarkNode(list: self)
        return String(cString: cmark_render_commonmark(node.cmark_node, CMARK_OPT_DEFAULT, 0))
    }

    func renderHTML(options: Document.RenderingOptions = .init()) -> String {
        let node = CommonMarkNode(list: self)
        return String(cString: cmark_render_html(node.cmark_node, options.rawValue))
    }
}

internal extension List {
    init?(commonMarkNode: CommonMarkNode) {
        guard case CMARK_NODE_LIST = commonMarkNode.type else {
            assertionFailure("Expecting 'CMARK_NODE_LIST' but instead got '\(commonMarkNode.typeString)'")
            return nil
        }

        self.init(
            style: Style(commonMarkNode.listType, commonMarkNode.listStart),
            spacing: commonMarkNode.listTight ? .tight : .loose,
            items: commonMarkNode.children.compactMap(Item.init)
        )
    }
}

private extension List.Style {
    init(_ listType: cmark_list_type, _ listStart: Int) {
        switch listType {
        case CMARK_ORDERED_LIST:
            self = .ordered(start: listStart)
        default:
            self = .bullet
        }
    }
}

internal extension CommonMarkNode {
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
            cmark_node_set_list_tight(cmark_node, 1)
        }

        list.items.map(CommonMarkNode.init(item:)).forEach { childNode in
            cmark_node_append_child(cmark_node, childNode.cmark_node)
        }

        self.init(cmark_node)
    }
}
