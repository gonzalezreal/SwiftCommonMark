import Foundation

extension String: ItemConvertible {
    public func asItems() -> [Item] {
        [Item(self)]
    }
}
