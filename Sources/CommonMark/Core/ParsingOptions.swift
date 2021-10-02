import Foundation
import cmark

extension Document {
  /// Options that affect the parsing of a CommonMark-formatted string into a ``Document``.
  public struct ParsingOptions: OptionSet {
    public var rawValue: Int32

    public init(rawValue: Int32 = CMARK_OPT_DEFAULT) {
      self.rawValue = rawValue
    }

    /// Convert straight quotes to curly, --- to em dashes, -- to en dashes.
    public static let smart = ParsingOptions(rawValue: CMARK_OPT_SMART)
  }
}
