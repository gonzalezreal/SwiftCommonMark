#if swift(>=5.4)
    import Foundation

    public struct Heading: BlockConvertible {
        private let level: Int
        private let inlines: [Inline]

        public init(level: Int = 1, @InlineBuilder content: () -> [Inline]) {
            self.level = level
            inlines = content()
        }

        public func asBlocks() -> [Block] {
            [.heading(text: inlines, level: level)]
        }
    }
#endif
