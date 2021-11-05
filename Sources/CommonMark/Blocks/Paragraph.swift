import Foundation

/// A paragraph element.
public struct Paragraph: Hashable {
  /// The inlines contained in this paragraph.
  public var text: [Inline]

  public init(text: [Inline]) {
    self.text = text
  }
}

#if swift(>=5.4)
  extension Paragraph {
    /// Creates a paragraph element.
    /// - Parameter text: An ``InlineArrayBuilder`` that creates the inlines in this paragraph.
    public init(@InlineArrayBuilder text: () -> [Inline]) {
      self.init(text: text())
    }
  }
#endif
