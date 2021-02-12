#if swift(>=5.4)
    import Foundation

    public struct Paragraph: BlockConvertible {
        private let inlines: [Inline]

        public init(_ text: String) {
            inlines = text.asInlines()
        }

        public init(@InlineBuilder content: () -> [Inline]) {
            inlines = content()
        }

        public func asBlocks() -> [Block] {
            [.paragraph(inlines)]
        }
    }
#endif
