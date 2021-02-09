import Foundation

public struct ForEach<Data, Content> where Data: RandomAccessCollection {
    private let data: Data
    private let content: (Data.Element) -> Content
}

public extension ForEach where Content: InlineConvertible {
    init(_ data: Data, @InlineBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ForEach: InlineConvertible where Content: InlineConvertible {
    public func asInlines() -> [Inline] {
        data.map(content).flatMap { $0.asInlines() }
    }
}

public extension ForEach where Content: BlockConvertible {
    init(_ data: Data, @BlockBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
}

extension ForEach: BlockConvertible where Content: BlockConvertible {
    public func asBlocks() -> [Block] {
        data.map(content).flatMap { $0.asBlocks() }
    }
}

extension ForEach: ItemConvertible where Content: BlockConvertible {
    public func asItems() -> [Item] {
        data.map(content).map { Item(blocks: $0.asBlocks()) }
    }
}
