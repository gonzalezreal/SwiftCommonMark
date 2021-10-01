#if swift(>=5.4)
  import Foundation

  public struct BlockQuote {
    public let items: [Block]

    public init(@BlockArrayBuilder items: () -> [Block]) {
      self.items = items()
    }
  }

  public struct List {
    public let items: [[Block]]
    public let type: ListType
    public let tight: Bool

    public init(
      type: ListType = .bullet, tight: Bool = true, @ItemArrayBuilder items: () -> [[Block]]
    ) {
      self.items = items()
      self.type = type
      // Force loose spacing if any of the items contains more than one paragraph
      let hasItemsWithMultipleParagraphs = self.items.contains { blocks in
        blocks.filter(\.isParagraph).count > 1
      }
      self.tight = hasItemsWithMultipleParagraphs ? false : tight
    }

    public init(start: Int, tight: Bool = true, @ItemArrayBuilder items: () -> [[Block]]) {
      self.init(type: .ordered(start: start), tight: tight, items: items)
    }
  }

  extension Block {
    fileprivate var isParagraph: Bool {
      guard case .paragraph = self else { return false }
      return true
    }
  }

  public struct Paragraph {
    public let text: [Inline]

    public init(@InlineArrayBuilder text: () -> [Inline]) {
      self.text = text()
    }
  }

  public struct Heading {
    public let text: [Inline]
    public let level: Int

    public init(level: Int = 1, @InlineArrayBuilder text: () -> [Inline]) {
      self.text = text()
      self.level = level
    }
  }

  public struct ThematicBreak {
    public init() {}
  }

  @resultBuilder
  public enum BlockArrayBuilder {
    public static func buildBlock(_ components: [Block]...) -> [Block] {
      components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [Block] {
      [.paragraph(text: [.text(expression)])]
    }

    public static func buildExpression(_ expression: BlockQuote) -> [Block] {
      [.blockQuote(items: expression.items)]
    }

    public static func buildExpression(_ expression: List) -> [Block] {
      [.list(items: expression.items, type: expression.type, tight: expression.tight)]
    }

    public static func buildExpression(_ expression: Code) -> [Block] {
      [.code(text: expression.text + "\n", info: expression.info)]
    }

    public static func buildExpression(_ expression: Paragraph) -> [Block] {
      [.paragraph(text: expression.text)]
    }

    public static func buildExpression(_ expression: Heading) -> [Block] {
      [.heading(text: expression.text, level: expression.level)]
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
