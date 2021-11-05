import Foundation
import cmark

internal class CommonMarkNode {
  let pointer: OpaquePointer
  let managed: Bool

  var type: cmark_node_type {
    cmark_node_get_type(pointer)
  }

  var typeString: String {
    String(cString: cmark_node_get_type_string(pointer))
  }

  var literal: String? {
    guard let literal = cmark_node_get_literal(pointer) else { return nil }
    return String(cString: literal)
  }

  var url: String? {
    guard let url = cmark_node_get_url(pointer) else { return nil }
    return String(cString: url)
  }

  var title: String? {
    guard let title = cmark_node_get_title(pointer) else { return nil }
    return String(cString: title)
  }

  var fenceInfo: String? {
    guard let fenceInfo = cmark_node_get_fence_info(pointer) else { return nil }
    return String(cString: fenceInfo)
  }

  var headingLevel: Int {
    Int(cmark_node_get_heading_level(pointer))
  }

  var listType: cmark_list_type {
    cmark_node_get_list_type(pointer)
  }

  var listStart: Int {
    Int(cmark_node_get_list_start(pointer))
  }

  var listTight: Bool {
    cmark_node_get_list_tight(pointer) != 0
  }

  var children: [CommonMarkNode] {
    var result: [CommonMarkNode] = []

    var child = cmark_node_first_child(pointer)
    while let unwrapped = child {
      result.append(CommonMarkNode(pointer: unwrapped, managed: false))
      child = cmark_node_next(child)
    }
    return result
  }

  init(pointer: OpaquePointer, managed: Bool) {
    self.pointer = pointer
    self.managed = managed
  }

  convenience init?(markdown: String, options: Int32) {
    guard let pointer = cmark_parse_document(markdown, markdown.utf8.count, options) else {
      return nil
    }
    self.init(pointer: pointer, managed: true)
  }

  deinit {
    guard managed else { return }
    cmark_node_free(pointer)
  }
}
