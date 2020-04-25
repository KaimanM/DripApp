//
//  WelcomeScreenBuilder.swift
//  Drip
//
//  Created by Kaiman Mehmet on 25/04/2020.
//  Copyright © 2020 Kaiman Mehmet. All rights reserved.
//

import UIKit

final class WelcomeScreenBuilder: ScreenBuilder {

    func build() -> WelcomeView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.welcome) as! WelcomeView

        view.presenter = WelcomePresenter(view: view)

        return view
    }
}
