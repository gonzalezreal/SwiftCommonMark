import Foundation

/// An ordered list.
public struct OrderedList: Hashable {
  /// The list items.
  public var items: [ListItem]

  /// The start number for this list.
  public var start: Int

  /// Determines if this list is tight or loose.
  public var tight: Bool

  public init(items: [ListItem], start: Int, tight: Bool) {
    self.items = items
    self.start = start
    // Force loose spacing if any of the items contains more than one paragraph
    let hasItemsWithMultipleParagraphs = self.items.contains { item in
      item.blocks.filter(\.isParagraph).count > 1
    }
    self.tight = hasItemsWithMultipleParagraphs ? false : tight
  }
}

#if swift(>=5.4)
  extension OrderedList {
    /// Creates an ordered list.
    /// - Parameters:
    ///   - start: The start number for this list.
    ///   - tight: A `Boolean` value that indicates if the list is tight or loose. This parameter is ignored if
    ///            any of the list items contain more than one paragraph.
    ///   - items: An ``ListItemArrayBuilder`` that creates the items in this list.
    public init(start: Int = 1, tight: Bool = true, @ListItemArrayBuilder items: () -> [ListItem]) {
      self.init(items: items(), start: start, tight: tight)
    }
  }
#endif
