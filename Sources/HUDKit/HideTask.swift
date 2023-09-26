import UIKit

struct HideTask: Equatable {
    let superview: WeakBox<UIView>
    let hudView: WeakBox<HUDView>
    let task: Task<Void, Error>
    
    init(
        superview: UIView,
        hudView: HUDView,
        task: Task<Void, Error>
    ) {
        self.superview = .init(superview)
        self.hudView = .init(hudView)
        self.task = task
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.superview.underlying == rhs.superview.underlying
    }
}
