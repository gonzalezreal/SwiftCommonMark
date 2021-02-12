#if swift(>=5.4)
    import Foundation

    extension String: BlockConvertible {
        public func asBlocks() -> [Block] {
            [.paragraph([.text(self)])]
        }
    }
#endif
