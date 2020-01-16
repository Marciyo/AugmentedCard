//
//  VisionManager.swift
//  eObuwie Merchant App
//
//  Created by Marcel Mierzejewski on 11/09/2018.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation
import FirebaseMLVision

typealias VisionCompletionHandler = (VisionText) -> ()

final class FirebaseOCRManager {

    private let vision = Vision.vision()

    func runOCR(forImage image: UIImage, completionHandler: @escaping VisionCompletionHandler) {
        let visionImage = VisionImage(image: image)
        let visionMetadata = VisionImageMetadata()
        visionMetadata.orientation = detectorOrientation(in: image)
        visionImage.metadata = visionMetadata
        let textDetector = vision.onDeviceTextRecognizer()

        textDetector.process(visionImage) { visionText, error in
            guard error == nil, let features = visionText else { return }
            completionHandler(features)
        }
    }

    private func detectorOrientation(in image: UIImage) -> VisionDetectorImageOrientation {
        switch image.imageOrientation {
        case .up:
            return .topLeft
        case .down:
            return .bottomRight
        case .left:
            return .leftBottom
        case .right:
            return .rightTop
        case .upMirrored:
            return .topRight
        case .downMirrored:
            return .bottomLeft
        case .leftMirrored:
            return .leftTop
        case .rightMirrored:
            return .rightBottom
        }
    }
}
