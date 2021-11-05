import Foundation

/// An image element.
public struct Image: Hashable {
  /// The inlines contained in this element.
  public var children: [Inline]

  /// The image URL.
  public var url: URL?

  /// The image title.
  public var title: String?

  public init(children: [Inline], url: URL?, title: String? = nil) {
    self.children = children
    self.url = url
    self.title = title
  }

  /// Creates an image element.
  /// - Parameters:
  ///   - url: The image URL.
  ///   - alt: The image alternate text.
  ///   - title: The image title.
  public init(url: URL?, alt: String? = nil, title: String? = nil) {
    self.init(children: alt.map { [.text($0)] } ?? [], url: url, title: title)
  }

  /// Creates an image element.
  /// - Parameters:
  ///   - destination: The path to the image.
  ///   - alt: The image alternate text.
  ///   - title: The image title.
  public init(_ destination: StaticString, alt: String? = nil, title: String? = nil) {
    self.init(
      children: alt.map { [.text($0)] } ?? [],
      url: URL(string: "\(destination)"),
      title: title
    )
  }
}
