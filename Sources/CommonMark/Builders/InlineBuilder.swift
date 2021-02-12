#if swift(>=5.4)
    import Foundation

    @resultBuilder
    public enum InlineBuilder {
        public static func buildBlock(_ values: InlineConvertible...) -> [Inline] {
            values.flatMap { $0.asInlines() }
        }

        public static func buildArray(_ components: [InlineConvertible]) -> [Inline] {
            components.flatMap { $0.asInlines() }
        }

        public static func buildOptional(_ component: InlineConvertible?) -> InlineConvertible {
            component ?? []
        }

        public static func buildEither(first: InlineConvertible) -> InlineConvertible {
            first
        }

        public static func buildEither(second: InlineConvertible) -> InlineConvertible {
            second
        }
    }
#endif
