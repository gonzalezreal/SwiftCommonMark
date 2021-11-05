#if swift(>=5.4)
  import Foundation

  /// A thematic break element.
  public struct ThematicBreak {
    public init() {}
  }

  /// Constructs ``Block`` arrays from multi-expression closures.
  @resultBuilder public enum BlockArrayBuilder {
    public static func buildBlock(_ components: [Block]...) -> [Block] {
      components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [Block] {
      [.paragraph(.init(text: [.text(expression)]))]
    }

    public static func buildExpression(_ expression: BlockQuote) -> [Block] {
      [.blockQuote(expression)]
    }

    public static func buildExpression(_ expression: BulletList) -> [Block] {
      [.bulletList(expression)]
    }

    public static func buildExpression(_ expression: OrderedList) -> [Block] {
      [.orderedList(expression)]
    }

    public static func buildExpression(_ expression: CodeBlock) -> [Block] {
      [.code(expression)]
    }

    public static func buildExpression(_ expression: HTMLBlock) -> [Block] {
      [.html(expression)]
    }

    public static func buildExpression(_ expression: Paragraph) -> [Block] {
      [.paragraph(expression)]
    }

    public static func buildExpression(_ expression: Heading) -> [Block] {
      [.heading(expression)]
    }

    public static func buildExpression(_: ThematicBreak) -> [Block] {
      [.thematicBreak]
    }

    public static func buildArray(_ components: [[Block]]) -> [Block] {
      components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Block]?) -> [Block] {
      component ?? []
    }

    public static func buildEither(first component: [Block]) -> [Block] {
      component
    }

    public static func buildEither(second component: [Block]) -> [Block] {
      component
    }
  }
#endif
