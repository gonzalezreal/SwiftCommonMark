import Foundation

@_functionBuilder
public enum InlineBuilder {
    public static func buildBlock(_ values: InlineConvertible...) -> [Inline] {
        values.flatMap { $0.asInlines() }
    }

    public static func buildIf(_ value: InlineConvertible?) -> InlineConvertible {
        value ?? []
    }

    public static func buildEither(first: InlineConvertible) -> InlineConvertible {
        first
    }

    public static func buildEither(second: InlineConvertible) -> InlineConvertible {
        second
    }
}
