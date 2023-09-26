import Foundation

final class WeakBox<Element>: Hashable where Element: AnyObject, Element: Hashable {
    weak var underlying: Element?

    init(_ value: Element?) {
        underlying = value
    }

    static func == (lhs: WeakBox<Element>, rhs: WeakBox<Element>) -> Bool {
        lhs.underlying == rhs.underlying
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(underlying)
    }
}
