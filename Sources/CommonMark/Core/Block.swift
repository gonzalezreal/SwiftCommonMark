import Foundation

/// The structural element of a CommonMark document.
public enum Block: Hashable {
    /// A section that is quoted from another source.
    case blockQuote(items: [Block])

    /// A list.
    case list(items: [[Block]], type: ListType = .bullet, tight: Bool = true)

    /// A section containing preformatted code.
    case code(text: String, info: String?)

    /// A group of lines that is treated as raw HTML.
    case html(text: String)

    /// A paragraph.
    case paragraph(text: [Inline])

    /// A heading.
    case heading(text: [Inline], level: Int)

    /// A thematic break.
    case thematicBreak
}
