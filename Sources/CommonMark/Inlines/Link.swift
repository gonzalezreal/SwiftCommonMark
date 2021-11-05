import Foundation

/// A link element.
public struct Link: Hashable {
  /// The inlines contained in this element.
  public var children: [Inline]

  /// The link destination.
  public var url: URL?

  /// The link title.
  public var title: String?

  public init(children: [Inline], url: URL?, title: String? = nil) {
    self.children = children
    self.url = url
    self.title = title
  }
}

#if swift(>=5.4)
  extension Link {
    /// Creates a link element.
    /// - Parameters:
    ///   - url: The link destination.
    ///   - title: The link title.
    ///   - children: An ``InlineArrayBuilder`` that creates the link text.
    public init(url: URL?, title: String? = nil, @InlineArrayBuilder children: () -> [Inline]) {
      self.init(children: children(), url: url, title: title)
    }

    /// Creates a link element.
    /// - Parameters:
    ///   - destination: The link destination.
    ///   - title: The link title.
    ///   - children: An ``InlineArrayBuilder`` that creates the link text.
    public init(
      _ destination: StaticString,
      title: String? = nil,
      @InlineArrayBuilder children: () -> [Inline]
    ) {
      self.init(children: children(), url: URL(string: "\(destination)"), title: title)
    }
  }
#endif
