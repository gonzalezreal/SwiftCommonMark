#if swift(>=5.4)
    import Foundation

    extension Array: ItemConvertible where Element == Item {
        public func asItems() -> [Item] {
            self
        }
    }
#endif
