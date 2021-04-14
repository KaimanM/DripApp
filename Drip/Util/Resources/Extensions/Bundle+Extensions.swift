import UIKit

extension Bundle {

    public var icon: UIImage? {

        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let files = primary["CFBundleIconFiles"] as? [String],
           let icon = files.last {
            return UIImage(named: icon)
        }

        return nil
    }

    public var appVersion: String {
        guard let appVersion = infoDictionary?["CFBundleShortVersionString"] as? String else { return "0.0.0" }
        return appVersion
    }
}
