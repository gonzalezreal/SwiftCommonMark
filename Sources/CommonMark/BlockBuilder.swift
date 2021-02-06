import Foundation

@_functionBuilder
public enum BlockBuilder {
    public static func buildBlock(_ values: BlockConvertible...) -> [Block] {
        values.flatMap { $0.asBlocks() }
    }

    public static func buildIf(_ value: BlockConvertible?) -> BlockConvertible {
        value ?? []
    }

    public static func buildEither(first: BlockConvertible) -> BlockConvertible {
        first
    }

    public static func buildEither(second: BlockConvertible) -> BlockConvertible {
        second
    }
}
