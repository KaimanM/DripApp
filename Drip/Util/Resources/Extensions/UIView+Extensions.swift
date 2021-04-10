//
//  UIView+Extensions.swift
//  Drip
//
//  Created by Kaiman Mehmet on 20/03/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    func centerHorizontallyInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        }
    }

    func centerVerticallyInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    func fillSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }

    func fillSuperViewSafely() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    func setEqualWidthTo(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

    func equalHeightTo(_ view: UIView, multiplier: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }

    func addVerticalDottedLine(color: UIColor = UIColor.white.withAlphaComponent(0.25)) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [1, 1]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.bounds.minY), CGPoint(x: 0, y: self.bounds.maxY)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
