#if swift(>=5.4)
    import Foundation

    extension String: InlineConvertible {
        public func asInlines() -> [Inline] {
            [.text(self)]
        }
    }
#endif
