#if swift(>=5.4)
    import Foundation

    public protocol InlineConvertible {
        func asInlines() -> [Inline]
    }
#endif
