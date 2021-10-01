import Foundation

/// A CommonMark document.
public struct Document: Hashable {
  /// The blocks that form this document.
  public var blocks: [Block]

  public init(markdown: String, options: ParsingOptions = .init()) throws {
    guard let node = CommonMarkNode(markdown: markdown, options: options.rawValue) else {
      throw ParsingError.invalidData
    }
    self.init(blocks: node.children.compactMap(Block.init))
  }

  public init(markdown: Data, options: ParsingOptions = .init()) throws {
    try self.init(markdown: String(decoding: markdown, as: UTF8.self), options: options)
  }

  public init(contentsOf url: URL, options: ParsingOptions = .init()) throws {
    try self.init(markdown: Data(contentsOf: url), options: options)
  }

  public init(blocks: [Block]) {
    self.blocks = blocks
  }

  #if swift(>=5.4)
    public init(@BlockArrayBuilder blocks: () -> [Block]) {
      self.init(blocks: blocks())
    }
  #endif
}

extension Document: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let markdown = try container.decode(String.self)

    try self.init(markdown: markdown)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(description)
  }
}
