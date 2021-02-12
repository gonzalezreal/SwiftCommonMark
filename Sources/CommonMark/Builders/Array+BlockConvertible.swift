#if swift(>=5.4)
    import Foundation

    extension Array: BlockConvertible where Element == Block {
        public func asBlocks() -> [Block] {
            self
        }
    }
#endif
