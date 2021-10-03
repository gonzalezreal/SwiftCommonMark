#if swift(>=5.4)
    import Foundation

    public struct CodeBlock: BlockConvertible {
        private let language: String
        private let text: String

        public init(language: String, text: () -> String) {
            self.language = language
            self.text = text() + "\n"
        }

        public func asBlocks() -> [Block] {
            [.code(text, language: language)]
        }
    }
#endif
