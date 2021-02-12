#if swift(>=5.4)
    import Foundation

    public struct Emphasis: InlineConvertible {
        private let inlines: [Inline]

        public init(_ text: String) {
            inlines = [.text(text)]
        }

        public init(@InlineBuilder content: () -> [Inline]) {
            inlines = content()
        }

        public func asInlines() -> [Inline] {
            [.emphasis(inlines)]
        }
    }
#endif
