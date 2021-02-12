#if swift(>=5.4)
    import Foundation

    extension String: ItemConvertible {
        public func asItems() -> [Item] {
            [Item(self)]
        }
    }
#endif
