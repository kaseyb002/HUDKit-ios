import UIKit

extension [UIView] {
   public func findRecursively<T: UIView>(
        _ type: T.Type = T.self,
        depth: Int = 0,
        maxDepth: Int = Int.max,
        condition: ((T) -> Bool) = { _ in true }
    ) -> T? {
        if let view: T = first(where: { subview in
            guard let subview = subview as? T else {
                return false
            }
            return condition(subview)
        }) as? T {
            return view
        }

        guard depth < maxDepth else {
            return nil
        }

        let subviews: [UIView] = flatMap(\.subviews)

        guard !subviews.isEmpty else {
            return nil
        }

        return subviews.findRecursively(
            depth: depth + 1,
            maxDepth: maxDepth,
            condition: condition
        )
    }
}
