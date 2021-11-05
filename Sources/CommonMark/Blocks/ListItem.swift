import Foundation

/// A list item.
public struct ListItem: Hashable {
  /// The blocks contained in this list item.
  public var blocks: [Block]

  public init(blocks: [Block]) {
    self.blocks = blocks
  }
}

#if swift(>=5.4)
  extension ListItem {
    /// Creates a list item.
    /// - Parameter blocks: A ``BlockArrayBuilder`` that creates the blocks of this list item.
    public init(@BlockArrayBuilder blocks: () -> [Block]) {
      self.init(blocks: blocks())
    }
  }
#endif
