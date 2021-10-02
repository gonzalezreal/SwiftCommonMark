#if swift(>=5.4)
  import Foundation

  /// A list item.
  public struct Item {
    /// The blocks contained in this list item.
    public let blocks: [Block]

    /// Creates a list item.
    /// - Parameter blocks: A ``BlockArrayBuilder`` that creates the blocks of this list item.
    public init(@BlockArrayBuilder blocks: () -> [Block]) {
      self.blocks = blocks()
    }
  }

  /// Constructs list items from multi-expression closures.
  @resultBuilder public enum ItemArrayBuilder {
    public static func buildBlock(_ components: [[Block]]...) -> [[Block]] {
      components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [[Block]] {
      [[.paragraph(text: [.text(expression)])]]
    }

    public static func buildExpression(_ expression: Item) -> [[Block]] {
      [expression.blocks]
    }

    public static func buildArray(_ components: [[[Block]]]) -> [[Block]] {
      components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [[Block]]?) -> [[Block]] {
      component ?? []
    }

    public static func buildEither(first component: [[Block]]) -> [[Block]] {
      component
    }

    public static func buildEither(second component: [[Block]]) -> [[Block]] {
      component
    }
  }
#endif
