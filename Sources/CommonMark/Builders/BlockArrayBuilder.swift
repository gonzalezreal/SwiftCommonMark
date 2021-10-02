#if swift(>=5.4)
  import Foundation

  /// A blockquote element.
  public struct BlockQuote {
    /// The blocks contained in this element.
    public let items: [Block]

    /// Creates a blockquote element with the given array of blocks.
    /// - Parameter items: A ``BlockArrayBuilder`` that creates the blocks of this blockquoute.
    public init(@BlockArrayBuilder items: () -> [Block]) {
      self.items = items()
    }
  }

  /// A list element.
  public struct List {
    /// The list items.
    public let items: [[Block]]

    /// The list type.
    public let type: ListType

    /// Determines if this list is tight or loose.
    public let tight: Bool

    /// Creates a list with the given type and spacing.
    /// - Parameters:
    ///   - type: The list type.
    ///   - tight: A `Boolean` value that indicates if the list is tight or loose. This parameter is ignored if
    ///            any of the list items contain more than one paragraph.
    ///   - items: An ``ItemArrayBuilder`` that creates the items in this list.
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

    /// Creates an ordered list.
    /// - Parameters:
    ///   - start: The start number for this list.
    ///   - tight: A `Boolean` value that indicates if the list is tight or loose. This parameter is ignored if
    ///            any of the list items contain more than one paragraph.
    ///   - items: An ``ItemArrayBuilder`` that creates the items in this list.
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

  /// A paragraph element.
  public struct Paragraph {
    /// The inlines contained in this paragraph.
    public let text: [Inline]

    /// Creates a paragraph element.
    /// - Parameter text: An ``InlineArrayBuilder`` that creates the inlines in this paragraph.
    public init(@InlineArrayBuilder text: () -> [Inline]) {
      self.text = text()
    }
  }

  /// A heading element.
  public struct Heading {
    /// The inlines contained in this heading.
    public let text: [Inline]

    /// The heading level.
    public let level: Int

    /// Creates a heading element with the given level.
    /// - Parameters:
    ///   - level: The heading level.
    ///   - text:  An ``InlineArrayBuilder`` that creates the inlines in this heading.
    public init(level: Int = 1, @InlineArrayBuilder text: () -> [Inline]) {
      self.text = text()
      self.level = level
    }
  }

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
