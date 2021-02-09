import Foundation

public struct LineBreak: InlineConvertible {
    public init() {}

    public func asInlines() -> [Inline] {
        [.lineBreak]
    }
}
