import Foundation

public struct CodeBlock: BlockConvertible {
    private let language: String
    private let text: String

    public init(language: String, text: () -> String) {
        self.language = language
        self.text = text()
    }

    public func asBlocks() -> [Block] {
        [.code(text, language: language)]
    }
}
