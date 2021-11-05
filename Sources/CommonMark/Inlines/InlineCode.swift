import Foundation

/// A code span.
public struct InlineCode: Hashable {
  /// The code contents.
  public var code: String

  /// Creates a code span.
  /// - Parameter text: The code contents.
  public init(_ code: String) {
    self.code = code
  }
}
