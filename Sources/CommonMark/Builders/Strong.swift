import Foundation

public struct Strong: InlineConvertible {
    private let inlines: [Inline]

    public init(_ text: String) {
        inlines = [.text(text)]
    }

    public init(@InlineBuilder content: () -> [Inline]) {
        inlines = content()
    }

    public func asInlines() -> [Inline] {
        [.strong(inlines)]
    }
}
