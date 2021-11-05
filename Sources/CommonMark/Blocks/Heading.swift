import Foundation

/// A heading element.
public struct Heading: Hashable {
  /// The inlines contained in this heading.
  public var text: [Inline]

  /// The heading level.
  public var level: Int

  public init(text: [Inline], level: Int) {
    self.text = text
    self.level = level
  }
}

#if swift(>=5.4)
  extension Heading {
    /// Creates a heading element with the given level.
    /// - Parameters:
    ///   - level: The heading level.
    ///   - text:  An ``InlineArrayBuilder`` that creates the inlines in this heading.
    public init(level: Int = 1, @InlineArrayBuilder text: () -> [Inline]) {
      self.init(text: text(), level: level)
    }
  }
#endif
