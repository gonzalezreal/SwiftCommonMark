import Foundation

extension Array: ItemConvertible where Element == Item {
    public func asItems() -> [Item] {
        self
    }
}
