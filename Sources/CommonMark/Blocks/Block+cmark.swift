import Foundation
import cmark

extension Block {
  /// Renders this block as CommonMark-formatted text.
  public func renderCommonMark() -> String {
    let node = CommonMarkNode(block: self, managed: true)
    return String(cString: cmark_render_commonmark(node.pointer, CMARK_OPT_DEFAULT, 0))
  }

  /// Renders this block as HTML.
  /// - Parameter options: Options that affect how the block is rendered as HTML.
  public func renderHTML(options: Document.RenderingOptions = .init()) -> String {
    let node = CommonMarkNode(block: self, managed: true)
    return String(cString: cmark_render_html(node.pointer, options.rawValue))
  }
}

extension Block {
  init?(commonMarkNode: CommonMarkNode) {
    switch commonMarkNode.type {
    case CMARK_NODE_BLOCK_QUOTE:
      self = .blockQuote(.init(items: commonMarkNode.children.compactMap(Block.init)))
    case CMARK_NODE_LIST where commonMarkNode.listType == CMARK_ORDERED_LIST:
      self = .orderedList(
        .init(
          items: commonMarkNode.children.compactMap(ListItem.init(commonMarkNode:)),
          start: commonMarkNode.listStart,
          tight: commonMarkNode.listTight
        )
      )
    case CMARK_NODE_LIST:
      self = .bulletList(
        .init(
          items: commonMarkNode.children.compactMap(ListItem.init(commonMarkNode:)),
          tight: commonMarkNode.listTight
        )
      )
    case CMARK_NODE_CODE_BLOCK:
      self = .code(
        .init(language: commonMarkNode.fenceInfo, code: { commonMarkNode.literal ?? "" })
      )
    case CMARK_NODE_HTML_BLOCK:
      self = .html(.init(html: commonMarkNode.literal ?? ""))
    case CMARK_NODE_PARAGRAPH:
      self = .paragraph(.init(text: commonMarkNode.children.compactMap(Inline.init)))
    case CMARK_NODE_HEADING:
      self = .heading(
        .init(
          text: commonMarkNode.children.compactMap(Inline.init),
          level: commonMarkNode.headingLevel
        )
      )
    case CMARK_NODE_THEMATIC_BREAK:
      self = .thematicBreak
    default:
      assertionFailure("Unknown block type '\(commonMarkNode.typeString)'")
      return nil
    }
  }
}

extension ListItem {
  fileprivate init?(commonMarkNode: CommonMarkNode) {
    guard case CMARK_NODE_ITEM = commonMarkNode.type else {
      assertionFailure("Expecting 'CMARK_NODE_ITEM' but instead got '\(commonMarkNode.typeString)'")
      return nil
    }
    self.init(blocks: commonMarkNode.children.compactMap(Block.init))
  }
}

extension CommonMarkNode {
  convenience init(block: Block, managed: Bool) {
    let pointer: OpaquePointer

    switch block {
    case let .blockQuote(blockQuote):
      pointer = cmark_node_new(CMARK_NODE_BLOCK_QUOTE)
      blockQuote.items.map {
        CommonMarkNode(block: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case let .bulletList(list):
      pointer = cmark_node_new(CMARK_NODE_LIST)
      cmark_node_set_list_type(pointer, CMARK_BULLET_LIST)
      cmark_node_set_list_tight(pointer, list.tight ? 1 : 0)
      list.items.map(CommonMarkNode.init(listItem:)).forEach { childNode in
        cmark_node_append_child(pointer, childNode.pointer)
      }
    case let .orderedList(list):
      pointer = cmark_node_new(CMARK_NODE_LIST)
      cmark_node_set_list_type(pointer, CMARK_ORDERED_LIST)
      cmark_node_set_list_start(pointer, Int32(list.start))
      cmark_node_set_list_tight(pointer, list.tight ? 1 : 0)
      list.items.map(CommonMarkNode.init(listItem:)).forEach { childNode in
        cmark_node_append_child(pointer, childNode.pointer)
      }
    case let .code(codeBlock):
      pointer = cmark_node_new(CMARK_NODE_CODE_BLOCK)
      cmark_node_set_literal(pointer, codeBlock.code)
      if let language = codeBlock.language, !language.isEmpty {
        cmark_node_set_fence_info(pointer, language)
      }
    case let .html(htmlBlock):
      pointer = cmark_node_new(CMARK_NODE_HTML_BLOCK)
      cmark_node_set_literal(pointer, htmlBlock.html)
    case let .paragraph(paragraph):
      pointer = cmark_node_new(CMARK_NODE_PARAGRAPH)
      paragraph.text.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case let .heading(heading):
      pointer = cmark_node_new(CMARK_NODE_HEADING)
      cmark_node_set_heading_level(pointer, Int32(heading.level))
      heading.text.map {
        CommonMarkNode(inline: $0, managed: false)
      }.forEach { node in
        cmark_node_append_child(pointer, node.pointer)
      }
    case .thematicBreak:
      pointer = cmark_node_new(CMARK_NODE_THEMATIC_BREAK)
    }

    self.init(pointer: pointer, managed: managed)
  }
}

extension CommonMarkNode {
  fileprivate convenience init(listItem: ListItem) {
    let pointer: OpaquePointer = cmark_node_new(CMARK_NODE_ITEM)
    listItem.blocks.map {
      CommonMarkNode(block: $0, managed: false)
    }.forEach { node in
      cmark_node_append_child(pointer, node.pointer)
    }

    self.init(pointer: pointer, managed: false)
  }
}
