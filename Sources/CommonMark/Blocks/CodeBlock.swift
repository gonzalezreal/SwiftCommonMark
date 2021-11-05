import Foundation

/// A code block.
public struct CodeBlock: Hashable {
  /// The code contents.
  public var code: String

  /// The code block language.
  public var language: String?

  public init(code: String, language: String? = nil) {
    self.code = code
    self.language = language
  }

  /// Creates a code block.
  /// - Parameters:
  ///   - language: The code block language.
  ///   - text: The code block contents.
  public init(language: String? = nil, code: () -> String) {
    self.init(code: code(), language: language)
  }
}
