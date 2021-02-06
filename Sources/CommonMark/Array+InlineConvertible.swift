import Foundation

extension Array: InlineConvertible where Element == Inline {
    public func asInlines() -> [Inline] {
        self
    }
}
