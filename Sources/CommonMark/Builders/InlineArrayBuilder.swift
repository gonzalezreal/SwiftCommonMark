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

  /// A code block or span.
  public struct Code {
    /// The code contents.
    public let text: String

    /// The code block info.
    public let info: String?

    /// Creates a code span.
    /// - Parameter text: The code contents.
    public init(_ text: String) {
      self.text = text
      info = nil
    }

    /// Creates a code block.
    /// - Parameters:
    ///   - language: The code block language.
    ///   - text: The code block contents.
    public init(language: String? = nil, text: () -> String) {
      self.text = text()
      info = language
    }
  }

  /// An emphasized element.
  public struct Emphasis {
    /// The inlines contained in this element.
    public let children: [Inline]

    /// Creates an emphasized text element.
    /// - Parameter text: The emphasized text.
    public init(_ text: String) {
      self.init(children: { text })
    }

    /// Creates an emphasized element.
    /// - Parameter children: An ``InlineArrayBuilder`` that creates the inlines in this element.
    public init(@InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
    }
  }

  /// An strongly emphasized element.
  public struct Strong {
    /// The inlines contained in this element.
    public let children: [Inline]

    /// Creates an strongly emphasized text element.
    /// - Parameter text: The emphasized text.
    public init(_ text: String) {
      self.init(children: { text })
    }

    /// Creates an strongly emphasized element.
    /// - Parameter children: An ``InlineArrayBuilder`` that creates the inlines in this element.
    public init(@InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
    }
  }

  /// A link element.
  public struct Link {
    /// The inlines contained in this element.
    public let children: [Inline]

    /// The link destination.
    public let url: URL?

    /// The link title.
    public let title: String?

    /// Creates a link element.
    /// - Parameters:
    ///   - url: The link destination.
    ///   - title: The link title.
    ///   - children: An ``InlineArrayBuilder`` that creates the link text.
    public init(url: URL?, title: String? = nil, @InlineArrayBuilder children: () -> [Inline]) {
      self.children = children()
      self.url = url
      self.title = title
    }

    /// Creates a link element.
    /// - Parameters:
    ///   - destination: The link destination.
    ///   - title: The link title.
    ///   - children: An ``InlineArrayBuilder`` that creates the link text.
    public init(
      _ destination: StaticString, title: String? = nil,
      @InlineArrayBuilder children: () -> [Inline]
    ) {
      self.children = children()
      url = URL(string: "\(destination)")
      self.title = title
    }
  }

  /// An image element.
  public struct Image {
    /// The inlines contained in this element.
    public let children: [Inline]

    /// The image URL.
    public let url: URL?

    /// The image title.
    public let title: String?

    /// Creates an image element.
    /// - Parameters:
    ///   - url: The image URL.
    ///   - alt: The image alternate text.
    ///   - title: The image title.
    public init(url: URL?, alt: String? = nil, title: String? = nil) {
      children = alt.map { [.text($0)] } ?? []
      self.url = url
      self.title = title
    }

    /// Creates an image element.
    /// - Parameters:
    ///   - destination: The path to the image.
    ///   - alt: The image alternate text.
    ///   - title: The image title.
    public init(_ destination: StaticString, alt: String? = nil, title: String? = nil) {
      children = alt.map { [.text($0)] } ?? []
      url = URL(string: "\(destination)")
      self.title = title
    }
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
