#if swift(>=5.4)
    import Foundation

    @resultBuilder
    public enum BlockBuilder {
        public static func buildBlock(_ values: BlockConvertible...) -> [Block] {
            values.flatMap { $0.asBlocks() }
        }

        public static func buildArray(_ components: [BlockConvertible]) -> [Block] {
            components.flatMap { $0.asBlocks() }
        }

        public static func buildOptional(_ component: BlockConvertible?) -> BlockConvertible {
            component ?? []
        }

        public static func buildEither(first: BlockConvertible) -> BlockConvertible {
            first
        }

        public static func buildEither(second: BlockConvertible) -> BlockConvertible {
            second
        }
    }
#endif
