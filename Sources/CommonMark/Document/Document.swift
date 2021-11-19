import Foundation

/// A value type that stores a CommonMark document as a sequence of blocks.
///
/// A CommonMark document consists of a sequence of blocks—structural elements like paragraphs,
/// block quotations, lists, headings, rules, and code blocks. Some blocks, like blockquotes and list
/// items, contain other blocks; others, like headings and paragraphs, contain inline text, links,
/// emphasized text, images, code spans, etc.
///
/// You can create a ``Document`` by passing a CommonMark-formatted `String` or `Data`
/// instance to initializers like ``init(markdown:options:)``.
/// ```swift
/// do {
///   let document = try Document(
///     markdown: "You can try **CommonMark** [here](https://spec.commonmark.org/dingus/)."
///   )
/// } catch {
///   print("Couldn't parse document.")
/// }
/// ```
///
/// From Swift 5.4 onwards, you can create a ``Document`` by passing an array of ``Block``s
/// constructed with a ``BlockArrayBuilder``.
/// ```swift
/// let document = Document {
///   Heading(level: 2) {
///     "Markdown lists"
///   }
///   Paragraph {
///     "Sometimes you want numbered lists:"
///   }
///   OrderedList {
///     "One"
///     "Two"
///     "Three"
///   }
///   Paragraph {
///     "Sometimes you want bullet points:"
///   }
///   BulletList {
///     ListItem {
///       Paragraph {
///         "Start a line with a "
///         Strong("star")
///       }
///     }
///     ListItem {
///       "Profit!"
///     }
///     ListItem {
///       "And you can have sub points:"
///       BulletList {
///         "Like this"
///         "And this"
///       }
///     }
///   }
/// }
/// ```
///
/// You can inspect the elements of a ``Document`` by accessing its ``blocks`` property.
/// ```swift
/// for block in document.blocks {
///   switch block {
///   case .blockQuote(let blockQuote):
///     for item in blockQuote.items {
///       // Inspect the item
///     }
///   case .bulletList(let bulletList):
///     for item in bulletList.items {
///       // Inspect the list item
///     }
///   case .orderedList(let orderedList):
///     for item in orderedList.items {
///       // Inspect the list item
///     }
///   case .code(let codeBlock):
///     print(codeBlock.language)
///     print(codeBlock.code)
///   case .html(let htmlBlock):
///     print(htmlBlock.html)
///   case .paragraph(let paragraph):
///     for inline in paragraph.text {
///       // Inspect the inline
///     }
///   case .heading(let heading):
///     print(heading.level)
///     for inline in heading.text {
///       // Inspect the inline
///     }
///   case .thematicBreak:
///     // A thematic break
///   }
/// }
/// ```
///
/// You can get back the CommonMark formatted text for a ``Document`` or render it as HTML.
/// ```swift
/// let markdown = document.renderCommonMark()
/// let html = document.renderHTML()
/// ```
public struct Document: Hashable {
  /// The blocks that form this document.
  public var blocks: [Block]

  /// Creates a document from a CommonMark-formatted string using the provided options.
  /// - Parameters:
  ///   - markdown: The string that contains the CommonMark formatting.
  ///   - options: Options that affect how the initializer parses the CommonMark string. Defaults to no options.
  public init(markdown: String, options: ParsingOptions = .init()) throws {
    guard let node = CommonMarkNode(markdown: markdown, options: options.rawValue) else {
      throw ParsingError.invalidData
    }
    self.init(blocks: node.children.compactMap(Block.init))
  }

  /// Creates a document from a CommonMark-formatted data using the provided options.
  /// - Parameters:
  ///   - markdown: The `Data` instance that contains the CommonMark formatting.
  ///   - options: Options that affect how the initializer parses the CommonMark string. Defaults to no options.
  public init(markdown: Data, options: ParsingOptions = .init()) throws {
    try self.init(markdown: String(decoding: markdown, as: UTF8.self), options: options)
  }

  /// Creates a document from the contents of a specified URL that contains CommonMark-formatted data, using the provided options.
  /// - Parameters:
  ///   - url: The URL to load CommonMark-formatted data from.
  ///   - options: Options that affect how the initializer parses the CommonMark string. Defaults to no options.
  public init(contentsOf url: URL, options: ParsingOptions = .init()) throws {
    try self.init(markdown: Data(contentsOf: url), options: options)
  }

  /// Creates a document with the given array of blocks.
  /// - Parameter blocks: The blocks that will form the document.
  public init(blocks: [Block]) {
    self.blocks = blocks
  }

  #if swift(>=5.4)
    /// Creates a document with the given array of blocks.
    /// - Parameter blocks: A ``BlockArrayBuilder`` that creates the blocks of this document.
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
