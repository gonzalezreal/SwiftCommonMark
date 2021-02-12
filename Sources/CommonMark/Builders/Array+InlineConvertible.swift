#if swift(>=5.4)
    import Foundation

    extension Array: InlineConvertible where Element == Inline {
        public func asInlines() -> [Inline] {
            self
        }
    }
#endif
