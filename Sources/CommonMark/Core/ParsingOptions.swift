import cmark
import Foundation

public extension Document {
    struct ParsingOptions: OptionSet {
        public var rawValue: Int32

        public init(rawValue: Int32 = CMARK_OPT_DEFAULT) {
            self.rawValue = rawValue
        }

        /// Convert straight quotes to curly, --- to em dashes, -- to en dashes.
        public static let smart = ParsingOptions(rawValue: CMARK_OPT_SMART)
    }
}
