import Foundation

/// A bullet list.
public struct BulletList: Hashable {
  /// The list items.
  public var items: [ListItem]

  /// Determines if this list is tight or loose.
  public var tight: Bool

  public init(items: [ListItem], tight: Bool) {
    self.items = items

    // Force loose spacing if any of the items contains more than one paragraph
    let hasItemsWithMultipleParagraphs = self.items.contains { item in
      item.blocks.filter(\.isParagraph).count > 1
    }
    self.tight = hasItemsWithMultipleParagraphs ? false : tight
  }
}

#if swift(>=5.4)
  extension BulletList {
    /// Creates a bullet list.
    /// - Parameters:
    ///   - tight: A `Boolean` value that indicates if the list is tight or loose. This parameter is ignored if
    ///            any of the list items contain more than one paragraph.
    ///   - items: An ``ListItemArrayBuilder`` that creates the items in this list.
    public init(tight: Bool = true, @ListItemArrayBuilder items: () -> [ListItem]) {
      self.init(items: items(), tight: tight)
    }
  }
#endif
