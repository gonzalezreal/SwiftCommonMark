import Foundation

public extension URL {
    init(_ string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            fatalError("Invalid static URL string: \(string)")
        }

        self = url
    }
}
