import Foundation

@_functionBuilder
public enum ItemBuilder {
    public static func buildBlock(_ values: ItemConvertible...) -> [Item] {
        values.flatMap { $0.asItems() }
    }

    public static func buildIf(_ value: ItemConvertible?) -> ItemConvertible {
        value ?? []
    }

    public static func buildEither(first: ItemConvertible) -> ItemConvertible {
        first
    }

    public static func buildEither(second: ItemConvertible) -> ItemConvertible {
        second
    }
}
