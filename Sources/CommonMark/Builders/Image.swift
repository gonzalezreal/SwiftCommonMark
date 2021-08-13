#if swift(>=5.4)
    import Foundation

    public struct Image: InlineConvertible {
        private let url: URL?
        private let title: String?
        private let inlines: [Inline]

        public init(url: URL?, title: String? = nil, @InlineBuilder content: () -> [Inline]) {
            self.url = url
            self.title = title
            inlines = content()
        }

        public init(url: URL?, title: String? = nil) {
            self.url = url
            self.title = title
            inlines = []
        }

        public func asInlines() -> [Inline] {
            [.image(children: inlines, url: url, title: title)]
        }
    }
#endif
