import Foundation

/// The structural element of a CommonMark document.
public enum Block: Hashable {
  /// A section that is quoted from another source.
  case blockQuote(BlockQuote)

  /// A bullet list.
  case bulletList(BulletList)

  /// An ordered list.
  case orderedList(OrderedList)

  /// A section containing preformatted code.
  case code(CodeBlock)

  /// A group of lines that is treated as raw HTML.
  case html(HTMLBlock)

  /// A paragraph.
  case paragraph(Paragraph)

  /// A heading.
  case heading(Heading)

  /// A thematic break.
  case thematicBreak
}

extension Block {
  var isParagraph: Bool {
    guard case .paragraph = self else { return false }
    return true
  }
}
