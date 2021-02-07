import Foundation

extension String: BlockConvertible {
    public func asBlocks() -> [Block] {
        [.paragraph([.text(self)])]
    }
}
