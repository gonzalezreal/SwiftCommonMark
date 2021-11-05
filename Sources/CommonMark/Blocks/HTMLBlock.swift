import Foundation

public struct HTMLBlock: Hashable {
  public var html: String

  public init(html: String) {
    self.html = html
  }

  public init(html: () -> String) {
    self.init(html: html())
  }
}
