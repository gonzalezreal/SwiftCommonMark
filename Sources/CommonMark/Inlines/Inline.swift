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
  case code(InlineCode)

  /// Raw HTML.
  case html(InlineHTML)

  /// Emphasis.
  case emphasis(Emphasis)

  /// Strong emphasis.
  case strong(Strong)

  /// Link.
  case link(Link)

  /// Image.
  case image(Image)
}
