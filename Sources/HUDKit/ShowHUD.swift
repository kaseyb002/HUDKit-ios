import UIKit

private let haptic: UIImpactFeedbackGenerator = .init(style: .medium)

private var hideTasks: [HideTask] = []

private func existingTask(for superview: UIView) -> HideTask? {
    hideTasks.first(where: { $0.superview.underlying == superview })
}

public func showHUD(
    _ icon: UIImage? = nil,
    title: String? = nil,
    showSpinner: Bool = false,
    playHaptic: Bool = true,
    duration: TimeInterval? = 2.0
) {
    Task { @MainActor in
        guard let topView: UIView = topViewController(controller: HUD.keyWindow?.rootViewController)?.view else {
            return
        }

        removeHUDViewIfNeeded(from: topView)

        let hudView: HUDView = makeHUDView(
            icon: icon,
            title: title,
            showSpinner: showSpinner,
            topView: topView
        )

        present(
            hudView: hudView,
            on: topView
        )

        if let duration: TimeInterval = duration {
            hide(
                hud: hudView,
                in: topView,
                afterDelay: duration
            )
        }

        if playHaptic {
            haptic.impactOccurred()
        }
    }
}

public func hideHUD() {
    Task { @MainActor in
        guard let topView: UIView = topViewController(controller: HUD.keyWindow?.rootViewController)?.view,
              let hudView: HUDView = topView.subviews.findRecursively(HUDView.self),
              let superview: UIView = hudView.superview
        else {
            return
        }

        hide(hudView: hudView, in: superview)
    }
}

private func removeHUDViewIfNeeded(from topView: UIView) {
    if let hudView: HUDView = topView.subviews.findRecursively(HUDView.self) {
        immediatelyRemove(hudView)
    }
    removeHideTask(for: topView)
}

private func makeHUDView(
    icon: UIImage?,
    title: String?,
    showSpinner: Bool,
    topView: UIView
) -> HUDView {
    let hudView: HUDView = .init()
    hudView.label.text = title
    if let title: String = title {
        hudView.label.text = title
        hudView.label.isHidden = false
    } else {
        hudView.label.isHidden = true
    }
    if let icon: UIImage = icon {
        hudView.iconView.image = icon.withRenderingMode(.alwaysTemplate)
        hudView.iconView.isHidden = false
    } else {
        hudView.iconView.isHidden = true
    }
    hudView.spinner.isHidden = !showSpinner
    hudView.translatesAutoresizingMaskIntoConstraints = false
    topView.addSubview(hudView)
    hudView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    topView.centerYAnchor.constraint(equalTo: hudView.centerYAnchor).isActive = true
    hudView.widthAnchor.constraint(lessThanOrEqualTo: topView.widthAnchor, constant: -20).isActive = true
    hudView.alpha = 0
    hudView.transform = .init(scaleX: 0.01, y: 0.01)
    return hudView
}

private func present(
    hudView: HUDView,
    on topView: UIView
) {
    topView.layoutIfNeeded()
    UIView.animate(withDuration: 0.25) {
        hudView.alpha = 1
        hudView.transform = .identity
        topView.layoutIfNeeded()
    }
}

private func hide(
    hud: HUDView,
    in superview: UIView,
    afterDelay duration: TimeInterval
) {
    let task: Task<Void, Error> = Task {
        try await Task.sleep(for: .seconds(duration))
        await MainActor.run {
            guard let existingTask: HideTask = existingTask(for: superview),
                    existingTask.task.isCancelled == false
            else {
                immediatelyRemove(hud)
                removeHideTask(for: superview)
                return
            }
            hide(hudView: hud, in: superview)
        }
    }
    hideTasks.append(.init(
        superview: superview,
        hudView: hud,
        task: task
    ))
}

private func hide(
    hudView: HUDView,
    in superview: UIView
) {
    superview.layoutIfNeeded()
    UIView.animate(
        withDuration: 0.4,
        delay: 0,
        animations: {
            hudView.transform = .init(translationX: 0, y: 15)
            hudView.alpha = 0
            superview.layoutIfNeeded()
        },
        completion: { isCompleted in
            guard isCompleted else { return }
            immediatelyRemove(hudView)
            removeHideTask(for: superview)
        }
    )
}

private func immediatelyRemove(_ hudView: HUDView) {
    if let superview: UIView = hudView.superview {
        removeHideTask(for: superview)
    }
    hudView.removeFromSuperview()
}

private func removeHideTask(for superview: UIView) {
    guard let hideTask: HideTask = existingTask(for: superview) else {
        return
    }
    hideTask.task.cancel()
    hideTasks.removeAll(where: { $0 == hideTask })
}
