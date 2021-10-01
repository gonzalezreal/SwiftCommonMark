import Foundation

/// An inline-level element in a heading or paragraph.
public enum Inline: Hashable {
  /// Textual content.
  case text(String)

  /// Soft line break.
  case softBreak

  /// Hard line break.
  case lineBreak

  /// Code span.
  case code(String)

  /// Raw HTML.
  case html(String)

  /// Emphasis.
  case emphasis(children: [Inline])

  /// Strong emphasis.
  case strong(children: [Inline])

  /// Link.
  case link(children: [Inline], url: URL?, title: String? = nil)

  /// Image.
  case image(children: [Inline], url: URL?, title: String? = nil)
}
