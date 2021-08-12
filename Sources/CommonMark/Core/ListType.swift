import Foundation

public enum ListType: Hashable {
    case bullet
    case ordered(start: Int)
}
