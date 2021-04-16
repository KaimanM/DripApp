import UIKit

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static var dripPrimary: UIColor = UIColor(named: "dripPrimary") ?? .blue
    static var dripSecondary: UIColor = UIColor(named: "dripSecondary") ?? .cyan
    static var dripMerged: UIColor = UIColor(named: "dripMerged") ?? .blue
    static var dripShadow: UIColor = UIColor(named: "dripShadow") ?? .darkGray
    static var infoPanelBG: UIColor = UIColor(named: "infoPanelBG") ?? .gray
    static var infoPanelDark: UIColor = UIColor(named: "infoPanelDark") ?? .darkGray
    static var infoPanelLight: UIColor = UIColor(named: "infoPanelLight") ?? .lightGray
    static var whiteText: UIColor = UIColor(named: "whiteText") ?? .white
    static var darkGrayText: UIColor = UIColor(named: "lightGrayText") ?? .lightGray
    static var todaysDate: UIColor = UIColor(named: "todaysDate") ?? .red
}
