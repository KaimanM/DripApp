//
//  ScreenBuilder.swift
//  Drip
//
//  Created by Kaiman Mehmet on 25/04/2020.
//  Copyright © 2020 Kaiman Mehmet. All rights reserved.
//

import UIKit

protocol ScreenBuilder {
    associatedtype Screen: UIViewController
    func build() -> Screen
}

