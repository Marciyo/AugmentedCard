//
//  CameraOverlayView.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 30/04/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class CameraOverlayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        isUserInteractionEnabled = false

        let width = frame.width * 0.8
        let height = width * 9 / 15

        let path = UIBezierPath(rect: CGRect(x: frame.midX - 0.5 * width, y: frame.midY - 0.6 * height,
                                             width: width, height: height))
        let maskLayer = CAShapeLayer()
        path.append(UIBezierPath(rect: bounds))
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
