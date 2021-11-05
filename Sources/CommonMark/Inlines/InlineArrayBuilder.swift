#if swift(>=5.4)
  import Foundation

  /// A soft line break.
  public struct SoftBreak {
    public init() {}
  }

  /// A hard line break.
  public struct LineBreak {
    public init() {}
  }

  /// Constructs ``Inline`` arrays from multi-expression closures.
  @resultBuilder public enum InlineArrayBuilder {
    public static func buildBlock(_ components: [Inline]...) -> [Inline] {
      components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: String) -> [Inline] {
      [.text(expression)]
    }

    public static func buildExpression(_: SoftBreak) -> [Inline] {
      [.softBreak]
    }

    public static func buildExpression(_: LineBreak) -> [Inline] {
      [.lineBreak]
    }

    public static func buildExpression(_ expression: InlineCode) -> [Inline] {
      [.code(expression)]
    }

    public static func buildExpression(_ expression: InlineHTML) -> [Inline] {
      [.html(expression)]
    }

    public static func buildExpression(_ expression: Emphasis) -> [Inline] {
      [.emphasis(expression)]
    }

    public static func buildExpression(_ expression: Strong) -> [Inline] {
      [.strong(expression)]
    }

    public static func buildExpression(_ expression: Link) -> [Inline] {
      [.link(expression)]
    }

    public static func buildExpression(_ expression: Image) -> [Inline] {
      [.image(expression)]
    }

    public static func buildArray(_ components: [[Inline]]) -> [Inline] {
      components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Inline]?) -> [Inline] {
      component ?? []
    }

    public static func buildEither(first component: [Inline]) -> [Inline] {
      component
    }

    public static func buildEither(second component: [Inline]) -> [Inline] {
      component
    }
  }
#endif
