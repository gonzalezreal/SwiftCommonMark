import cmark
import Foundation

internal class CommonMarkNode {
    let cmark_node: OpaquePointer
    let weak: Bool

    var type: cmark_node_type {
        cmark_node_get_type(cmark_node)
    }

    var typeString: String {
        String(cString: cmark_node_get_type_string(cmark_node))
    }

    var literal: String? {
        guard let literal = cmark_node_get_literal(cmark_node) else { return nil }
        return String(cString: literal)
    }

    var url: String? {
        guard let url = cmark_node_get_url(cmark_node) else { return nil }
        return String(cString: url)
    }

    var title: String? {
        guard let title = cmark_node_get_title(cmark_node) else { return nil }
        return String(cString: title)
    }

    var fenceInfo: String? {
        guard let fenceInfo = cmark_node_get_fence_info(cmark_node) else { return nil }
        return String(cString: fenceInfo)
    }

    var headingLevel: Int {
        Int(cmark_node_get_heading_level(cmark_node))
    }

    var listType: cmark_list_type {
        cmark_node_get_list_type(cmark_node)
    }

    var listStart: Int {
        Int(cmark_node_get_list_start(cmark_node))
    }

    var listTight: Bool {
        cmark_node_get_list_tight(cmark_node) != 0
    }

    var children: [CommonMarkNode] {
        var result: [CommonMarkNode] = []

        var child = cmark_node_first_child(cmark_node)
        while let unwrapped = child {
            result.append(CommonMarkNode(unwrapped))
            child = cmark_node_next(child)
        }
        return result
    }

    init(_ cmark_node: OpaquePointer, weak: Bool = true) {
        self.cmark_node = cmark_node
        self.weak = weak
    }

    convenience init?(markdown: String, options: Int32) {
        guard let node = cmark_parse_document(markdown, markdown.utf8.count, options) else {
            return nil
        }
        self.init(node, weak: false)
    }

    deinit {
        guard !weak else { return }
        cmark_node_free(cmark_node)
    }
}
