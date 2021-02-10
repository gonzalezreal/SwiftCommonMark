import Foundation

@resultBuilder
public enum ItemBuilder {
    public static func buildBlock(_ values: ItemConvertible...) -> [Item] {
        values.flatMap { $0.asItems() }
    }

    public static func buildArray(_ components: [ItemConvertible]) -> [Item] {
        components.flatMap { $0.asItems() }
    }

    public static func buildOptional(_ value: ItemConvertible?) -> ItemConvertible {
        value ?? []
    }

    public static func buildEither(first: ItemConvertible) -> ItemConvertible {
        first
    }

    public static func buildEither(second: ItemConvertible) -> ItemConvertible {
        second
    }
}
