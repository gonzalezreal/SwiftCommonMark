import Foundation

extension Document {
  @available(*, deprecated, message: "This property has been removed and returns an empty set")
  public var imageURLs: Set<String> {
    []
  }

  @available(
    *, deprecated, message: "Use init(markdown:options:) to create a document from a string"
  )
  public init(_ content: String) {
    try! self.init(markdown: content)
  }

  @available(
    *, deprecated,
    message: "Use init(contentsOf:options:) to create a document from the contents of a URL"
  )
  public init(contentsOfFile path: String) throws {
    try self.init(markdown: .init(contentsOfFile: path))
  }

  @available(
    *, deprecated,
    message: "Use init(contentsOf:options:) to create a document from the contents of a URL"
  )
  public init(contentsOfFile path: String, encoding: String.Encoding) throws {
    try self.init(markdown: .init(contentsOfFile: path, encoding: encoding))
  }
}
