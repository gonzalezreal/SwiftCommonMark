#if swift(>=5.4)
    import Foundation

    public struct BlockQuote: BlockConvertible {
        private let blocks: [Block]

        public init(_ text: String) {
            blocks = text.asBlocks()
        }

        public init(@BlockBuilder content: () -> [Block]) {
            blocks = content()
        }

        public func asBlocks() -> [Block] {
            [.blockQuote(items: blocks)]
        }
    }
#endif
