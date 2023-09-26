import UIKit

@MainActor
func topViewController(
    controller: UIViewController?
) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return topViewController(
            controller: navigationController.visibleViewController
        )
    }

    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }

    if let presented: UIViewController = controller?.presentedViewController {
        return topViewController(controller: presented)
    }

    return controller
}
