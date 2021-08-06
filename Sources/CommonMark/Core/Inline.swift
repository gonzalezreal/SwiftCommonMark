import Foundation

/// A CommonMark document inline.
public enum Inline: Hashable {
    /// Plain textual content.
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
    case emphasis([Inline])

    /// Strong emphasis.
    case strong([Inline])

    /// Link.
    case link([Inline], url: String, title: String = "")

    /// Image.
    case image([Inline], url: String, title: String = "")
}
