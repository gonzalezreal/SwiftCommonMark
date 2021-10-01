#if swift(>=5.4)
  import Foundation

  public struct SoftBreak {
    public init() {}
  }

  public struct LineBreak {
    public init() {}
  }

  public struct Code {
    public let text: String
    public let info: String?

    public init(_ text: String) {
      self.text = text
      info = nil
    }

    public init(language: String? = nil, text: () -> String) {
      self.text = text()
      info = language
    }
  }

  public struct Emphasis {
    public let children: [Inline]

    public init(_ text: String) {
      self.init(children: { text })
    }

    public init(@InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
    }
  }

  public struct Strong {
    public let children: [Inline]

    public init(_ text: String) {
      self.init(children: { text })
    }

    public init(@InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
    }
  }

  public struct Link {
    public let children: [Inline]
    public let url: URL?
    public let title: String?

    public init(url: URL?, title: String? = nil, @InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
      self.url = url
      self.title = title
    }

    public init(
      _ destination: StaticString, title: String? = nil,
      @InlineArrayBuilder children: () -> [Inline]
    ) {
      self.children = children()
      url = URL(string: "\(destination)")
      self.title = title
    }
  }

  public struct Image {
    public let children: [Inline]
    public let url: URL?
    public let title: String?

    public init(url: URL?, alt: String? = nil, title: String? = nil) {
      children = alt.map { [.text($0)] } ?? []
      self.url = url
      self.title = title
    }

    public init(_ destination: StaticString, alt: String? = nil, title: String? = nil) {
      children = alt.map { [.text($0)] } ?? []
      url = URL(string: "\(destination)")
      self.title = title
    }
  }

  @resultBuilder
  public enum InlineArrayBuilder {
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

    public static func buildExpression(_ expression: Code) -> [Inline] {
      [.code(expression.text)]
    }

    public static func buildExpression(_ expression: Emphasis) -> [Inline] {
      [.emphasis(children: expression.children)]
    }

    public static func buildExpression(_ expression: Strong) -> [Inline] {
      [.strong(children: expression.children)]
    }

    public static func buildExpression(_ expression: Link) -> [Inline] {
      [.link(children: expression.children, url: expression.url, title: expression.title)]
    }

    public static func buildExpression(_ expression: Image) -> [Inline] {
      [.image(children: expression.children, url: expression.url, title: expression.title)]
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
