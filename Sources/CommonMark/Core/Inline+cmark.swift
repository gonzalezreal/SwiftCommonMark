import Foundation
import cmark

extension Inline {
  /// Renders this inline as CommonMark-formatted text.
  public func renderCommonMark() -> String {
    let node = CommonMarkNode(inline: self, managed: true)
    return String(cString: cmark_render_commonmark(node.pointer, CMARK_OPT_DEFAULT, 0))
  }

  /// Renders this inline as HTML.
  /// - Parameter options: Options that affect how the inline is rendered as HTML.
  public func renderHTML(options: Document.RenderingOptions = .init()) -> String {
    let node = CommonMarkNode(inline: self, managed: true)
    return String(cString: cmark_render_html(node.pointer, options.rawValue))
  }
}

extension Inline {
  init?(commonMarkNode: CommonMarkNode) {
    switch commonMarkNode.type {
    case CMARK_NODE_TEXT:
      self = .text(commonMarkNode.literal ?? "")
    case CMARK_NODE_SOFTBREAK:
      self = .softBreak
    case CMARK_NODE_LINEBREAK:
      self = .lineBreak
    case CMARK_NODE_CODE:
      self = .code(commonMarkNode.literal!)
    case CMARK_NODE_HTML_INLINE:
      self = .html(commonMarkNode.literal!)
    case CMARK_NODE_EMPH:
      self = .emphasis(children: commonMarkNode.children.compactMap(Inline.init))
    case CMARK_NODE_STRONG:
      self = .strong(children: commonMarkNode.children.compactMap(Inline.init))
    case CMARK_NODE_LINK:
      self = .link(
        children: commonMarkNode.children.compactMap(Inline.init),
        url: commonMarkNode.url.flatMap(URL.init(string:)),
        title: commonMarkNode.title?.isEmpty ?? true ? nil : commonMarkNode.title
      )
    case CMARK_NODE_IMAGE:
      self = .image(
        children: commonMarkNode.children.compactMap(Inline.init),
        url: commonMarkNode.url.flatMap(URL.init(string:)),
        title: commonMarkNode.title?.isEmpty ?? true ? nil : commonMarkNode.title
      )
    default:
      assertionFailure("Unknown inline type '\(commonMarkNode.typeString)'")
      return nil
    }
  }
}

extension CommonMarkNode {
  convenience init(inline: Inline, managed: Bool) {
    let pointer: OpaquePointer

    switch inline {
    case let .text(literal):
      pointer = cmark_node_new(CMARK_NODE_TEXT)
      cmark_node_set_literal(pointer, literal)
    case .softBreak:
      pointer = cmark_node_new(CMARK_NODE_SOFTBREAK)
    case .lineBreak:
      pointer = cmark_node_new(CMARK_NODE_LINEBREAK)
    case let .code(literal):
      pointer = cmark_node_new(CMARK_NODE_CODE)
      cmark_node_set_literal(pointer, literal)
    case let .html(literal):
      pointer = cmark_node_new(CMARK_NODE_HTML_INLINE)
      cmark_node_set_literal(pointer, literal)
    case let .emphasis(children):
      pointer = cmark_node_new(CMARK_NODE_EMPH)
      children.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case let .strong(children):
      pointer = cmark_node_new(CMARK_NODE_STRONG)
      children.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case let .link(children, url, title):
      pointer = cmark_node_new(CMARK_NODE_LINK)
      if let url = url {
        cmark_node_set_url(pointer, url.absoluteString)
      }
      if let title = title {
        cmark_node_set_title(pointer, title)
      }
      children.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case let .image(children, url, title):
      pointer = cmark_node_new(CMARK_NODE_IMAGE)
      if let url = url {
        cmark_node_set_url(pointer, url.absoluteString)
      }
      if let title = title {
        cmark_node_set_title(pointer, title)
      }
      children.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    }

    self.init(pointer: pointer, managed: managed)
  }
}
