#if swift(>=5.4)
    import Foundation

    public struct Link: InlineConvertible {
        private let url: URL?
        private let title: String?
        private let inlines: [Inline]

        public init(_ text: String, url: URL?, title: String? = nil) {
            inlines = [.text(text)]
            self.url = url
            self.title = title
        }

        public init(url: URL?, title: String? = nil, @InlineBuilder content: () -> [Inline]) {
            self.url = url
            self.title = title
            inlines = content()
        }

        public func asInlines() -> [Inline] {
            [.link(children: inlines, url: url, title: title)]
        }
    }
#endif
