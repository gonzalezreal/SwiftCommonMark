import Foundation

public struct Heading: BlockConvertible {
    private let level: Int
    private let inlines: [Inline]

    public init(level: Int = 1, @InlineBuilder _ content: () -> [Inline]) {
        self.level = level
        inlines = content()
    }

    public func asBlocks() -> [Block] {
        [.heading(inlines, level: level)]
    }
}
