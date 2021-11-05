import Foundation
import cmark

extension Document {
  /// Options that affect the rendering a ``Document`` as HTML.
  public struct RenderingOptions: OptionSet {
    public var rawValue: Int32

    public init(rawValue: Int32 = CMARK_OPT_DEFAULT) {
      self.rawValue = rawValue
    }

    /// Include a `data-sourcepos` attribute on all block elements.
    public static let sourcePosition = RenderingOptions(rawValue: CMARK_OPT_SOURCEPOS)

    /// Render `softbreak` elements as hard line breaks.
    public static let hardBreaks = RenderingOptions(rawValue: CMARK_OPT_HARDBREAKS)

    /// Render raw HTML and unsafe links (`javascript:`, `vbscript:`, `file:`, and `data:`, except for `image/png`, `image/gif`,
    /// `image/jpeg`, or `image/webp` mime types).  By default, raw HTML is replaced by a placeholder HTML comment. Unsafe links are
    /// replaced by empty strings.
    public static let unsafe = RenderingOptions(rawValue: CMARK_OPT_UNSAFE)

    /// Render `softBreak` elements as spaces.
    public static let noBreaks = RenderingOptions(rawValue: CMARK_OPT_NOBREAKS)
  }
}
