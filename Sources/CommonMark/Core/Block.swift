import Foundation

/// A CommonMark document block.
public enum Block: Hashable {
    /// A block quote.
    case blockQuote([Block])

    /// A list.
    case list(List)

    /// A code block.
    case code(String, language: String = "")

    /// A group of lines that is treated as raw HTML.
    case html(String)

    /// A paragraph.
    case paragraph([Inline])

    /// A heading.
    case heading([Inline], level: Int)

    /// A thematic break.
    case thematicBreak
}

internal extension Block {
    var isParagraph: Bool {
        guard case .paragraph = self else { return false }
        return true
    }
}
