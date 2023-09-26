import UIKit

public final class HUD {
    public static func setup(keyWindow: UIWindow) {
        Self.keyWindow = keyWindow
    }
    
    static var keyWindow: UIWindow?
}
