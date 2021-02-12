#if swift(>=5.4)
    import Foundation

    public struct Code: InlineConvertible {
        private let text: String

        public init(_ text: String) {
            self.text = text
        }

        public func asInlines() -> [Inline] {
            [.code(text)]
        }
    }
#endif
