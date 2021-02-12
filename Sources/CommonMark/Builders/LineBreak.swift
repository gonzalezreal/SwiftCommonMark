#if swift(>=5.4)
    import Foundation

    public struct LineBreak: InlineConvertible {
        public init() {}

        public func asInlines() -> [Inline] {
            [.lineBreak]
        }
    }
#endif
