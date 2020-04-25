//
//  UIViewController+ViewControllerName.swift
//  Drip
//
//  Created by Kaiman Mehmet on 25/04/2020.
//  Copyright © 2020 Kaiman Mehmet. All rights reserved.
//

import UIKit

extension UIViewController {
    static func create(_ name: ViewControllerName) -> UIViewController {
        return createOptional(name)!
    }
    static func createOptional(_ name: ViewControllerName) -> UIViewController? {
        return UIStoryboard(name: name.rawValue, bundle: nil).instantiateInitialViewController()
    }
}
