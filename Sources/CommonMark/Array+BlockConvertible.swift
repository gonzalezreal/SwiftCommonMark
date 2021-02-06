import Foundation

extension Array: BlockConvertible where Element == Block {
    public func asBlocks() -> [Block] {
        self
    }
}
