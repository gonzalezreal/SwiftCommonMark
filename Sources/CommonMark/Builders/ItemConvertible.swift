#if swift(>=5.4)
    import Foundation

    public protocol ItemConvertible {
        func asItems() -> [Item]
    }
#endif
