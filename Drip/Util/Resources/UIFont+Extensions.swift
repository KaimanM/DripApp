import UIKit

extension UIFont {
    static func SFProRounded(ofSize fontSize: CGFloat, fontWeight: UIFont.Weight) -> UIFont {
        // Here we get San Francisco with the desired weight
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)

        // Will be SF Compact or standard SF in case of failure.
        let font: UIFont

        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
        return font
    }
}
