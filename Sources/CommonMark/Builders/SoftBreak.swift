import Foundation

public struct SoftBreak: InlineConvertible {
    public init() {}

    public func asInlines() -> [Inline] {
        [.softBreak]
    }
}
