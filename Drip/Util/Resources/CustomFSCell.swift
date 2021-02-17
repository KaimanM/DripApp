//
//  CustomFSCell.swift
//  Drip
//
//  Created by Kaiman Mehmet on 16/02/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit
import FSCalendar

class CustomFSCell: FSCalendarCell {

    weak var ringView: ProgressRingView!

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let ringView = ProgressRingView()
        self.ringView = ringView
        ringView.setupRingView(progress: 0.5, colour: .dripMerged, shadowColour: .dripShadow, lineWidth: 6)
        self.contentView.addSubview(self.ringView)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.ringView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.contentView.bounds.width*0.9,
                                     height: self.contentView.bounds.height*0.9)
        ringView.center = contentView.center
        self.titleLabel.frame = self.contentView.bounds // Centers datelabel
        self.shapeLayer.path = getPath().cgPath // this and next line center date selected ring
        self.shapeLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.contentView.bounds.width*0.9,
                                     height: self.contentView.bounds.height*0.9)
    }

    private func getPath() -> UIBezierPath { // reduces size of selection ring
        let arcCenter = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        let radius = ringView.frame.height/3
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius,
                                        startAngle: -CGFloat.pi/2,
                                        endAngle: 1.5*CGFloat.pi,
                                        clockwise: true)
        return circularPath
    }

}
