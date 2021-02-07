import Foundation

extension String: InlineConvertible {
    public func asInlines() -> [Inline] {
        [.text(self)]
    }
}
