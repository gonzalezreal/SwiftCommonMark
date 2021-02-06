import Foundation

public struct Image: InlineConvertible {
    private let url: URL
    private let title: String
    private let inlines: [Inline]

    public init(url: URL, title: String = "", @InlineBuilder _ content: () -> [Inline]) {
        self.url = url
        self.title = title
        inlines = content()
    }

    public init(url: URL, title: String = "") {
        self.url = url
        self.title = title
        inlines = []
    }

    public func asInlines() -> [Inline] {
        [.image(inlines, url: url, title: title)]
    }
}
