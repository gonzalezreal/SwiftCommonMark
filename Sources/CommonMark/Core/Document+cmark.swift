import cmark
import Foundation

public extension Document {
    func renderCommonMark() -> String {
        let node = CommonMarkNode(document: self)
        return String(cString: cmark_render_commonmark(node.cmark_node, CMARK_OPT_DEFAULT, 0))
    }

    func renderHTML(options: RenderingOptions = .init()) -> String {
        let node = CommonMarkNode(document: self)
        return String(cString: cmark_render_html(node.cmark_node, options.rawValue))
    }
}

extension Document: CustomStringConvertible {
    public var description: String {
        renderCommonMark()
    }
}

internal extension CommonMarkNode {
    convenience init(document: Document) {
        let cmark_node: OpaquePointer = cmark_node_new(CMARK_NODE_DOCUMENT)

        document.blocks.map(CommonMarkNode.init(block:)).forEach { node in
            cmark_node_append_child(cmark_node, node.cmark_node)
        }

        self.init(cmark_node, weak: false)
    }
}
