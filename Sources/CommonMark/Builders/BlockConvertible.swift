#if swift(>=5.4)
    import Foundation

    public protocol BlockConvertible {
        func asBlocks() -> [Block]
    }
#endif
