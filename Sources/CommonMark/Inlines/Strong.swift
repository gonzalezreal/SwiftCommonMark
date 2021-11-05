import Foundation

/// An strongly emphasized element.
public struct Strong: Hashable {
  /// The inlines contained in this element.
  public var children: [Inline]

  public init(children: [Inline]) {
    self.children = children
  }

  /// Creates an strongly emphasized text element.
  /// - Parameter text: The emphasized text.
  public init(_ text: String) {
    self.init(children: [.text(text)])
  }
}

#if swift(>=5.4)
  extension Strong {
    /// Creates an strongly emphasized element.
    /// - Parameter children: An ``InlineArrayBuilder`` that creates the inlines in this element.
    public init(@InlineArrayBuilder children: () -> [Inline]) {
      self.init(children: children())
    }
  }
#endif
