import Foundation

public struct InlineHTML: Hashable {
  public var html: String

  public init(_ html: String) {
    self.html = html
  }
}
