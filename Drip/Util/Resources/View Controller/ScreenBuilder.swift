import UIKit

protocol ScreenBuilder {
    associatedtype Screen: UIViewController
    func build() -> Screen
}
