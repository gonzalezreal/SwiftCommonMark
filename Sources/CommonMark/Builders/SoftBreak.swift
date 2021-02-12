#if swift(>=5.4)
    import Foundation

    public struct SoftBreak: InlineConvertible {
        public init() {}

        public func asInlines() -> [Inline] {
            [.softBreak]
        }
    }
#endif
