import Foundation

public struct Paragraph: BlockConvertible {
    private let inlines: [Inline]

    public init(_ text: String) {
        inlines = text.asInlines()
    }

    public init(@InlineBuilder _ content: () -> [Inline]) {
        inlines = content()
    }

    public func asBlocks() -> [Block] {
        [.paragraph(inlines)]
    }
}
