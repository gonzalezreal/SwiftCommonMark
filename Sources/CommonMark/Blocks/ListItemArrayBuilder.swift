#if swift(>=5.4)
  import Foundation

  /// Constructs list items from multi-expression closures.
  @resultBuilder public enum ListItemArrayBuilder {
    public static func buildBlock(_ components: [ListItem]...) -> [ListItem] {
      components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [ListItem] {
      [ListItem(blocks: [.paragraph(.init(text: [.text(expression)]))])]
    }

    public static func buildExpression(_ expression: ListItem) -> [ListItem] {
      [expression]
    }

    public static func buildArray(_ components: [[ListItem]]) -> [ListItem] {
      components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [ListItem]?) -> [ListItem] {
      component ?? []
    }

    public static func buildEither(first component: [ListItem]) -> [ListItem] {
      component
    }

    public static func buildEither(second component: [ListItem]) -> [ListItem] {
      component
    }
  }
#endif
