import Foundation

/// A blockquote element.
public struct BlockQuote: Hashable {
  /// The blocks contained in this element.
  public var items: [Block]

  public init(items: [Block]) {
    self.items = items
  }
}

#if swift(>=5.4)
  extension BlockQuote {
    /// Creates a blockquote element with the given array of blocks.
    /// - Parameter items: A ``BlockArrayBuilder`` that creates the blocks of this blockquoute.
    public init(@BlockArrayBuilder items: () -> [Block]) {
      self.init(items: items())
    }
  }
#endif
