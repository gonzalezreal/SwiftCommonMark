#if swift(>=5.4)
    import Foundation

    public struct Item {
        public let blocks: [Block]

        public init(@BlockArrayBuilder blocks: () -> [Block]) {
            self.blocks = blocks()
        }
    }

    @resultBuilder
    public enum ItemArrayBuilder {
        public static func buildBlock(_ components: [[Block]]...) -> [[Block]] {
            components.flatMap { $0 }
        }

        public static func buildExpression(_ expression: String) -> [[Block]] {
            [[.paragraph(text: [.text(expression)])]]
        }

        public static func buildExpression(_ expression: Item) -> [[Block]] {
            [expression.blocks]
        }

        public static func buildArray(_ components: [[[Block]]]) -> [[Block]] {
            components.flatMap { $0 }
        }

        public static func buildOptional(_ component: [[Block]]?) -> [[Block]] {
            component ?? []
        }

        public static func buildEither(first component: [[Block]]) -> [[Block]] {
            component
        }

        public static func buildEither(second component: [[Block]]) -> [[Block]] {
            component
        }
    }
#endif
