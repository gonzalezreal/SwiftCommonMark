import Foundation
import cmark

extension Document {
  public func renderCommonMark() -> String {
    let node = CommonMarkNode(document: self)
    return String(cString: cmark_render_commonmark(node.pointer, CMARK_OPT_DEFAULT, 0))
  }

  public func renderHTML(options: RenderingOptions = .init()) -> String {
    let node = CommonMarkNode(document: self)
    return String(cString: cmark_render_html(node.pointer, options.rawValue))
  }
}

extension Document: CustomStringConvertible {
  public var description: String {
    renderCommonMark()
  }
}

extension CommonMarkNode {
  convenience init(document: Document) {
    let pointer: OpaquePointer = cmark_node_new(CMARK_NODE_DOCUMENT)

    document.blocks.map {
      CommonMarkNode(block: $0, managed: false)
    }.forEach { node in
      cmark_node_append_child(pointer, node.pointer)
    }

    self.init(pointer: pointer, managed: true)
  }
}
