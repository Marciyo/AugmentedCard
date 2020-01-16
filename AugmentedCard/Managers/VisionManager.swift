//
//  VisionManager.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 18/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Vision
import UIKit
import CoreImage

enum VisionError: Error {
    case readerInitializationFailed
}

final class VisionManager {
    private let context = CIContext(options: nil)

    private var detectRectangleRequest: VNRequest {
        let request = VNDetectRectanglesRequest(completionHandler: handleRectangles)
        request.maximumObservations = 1
        request.minimumConfidence = 0.8
        request.minimumAspectRatio = 1.5
        request.maximumAspectRatio = 3
        return request
    }
    private var lastObservation: VNDetectedObjectObservation?

    private var inputImage: CIImage!
    var finalImage = Dynamic<UIImage?>(nil)

    func recognizeRectangle(in buffer: CVPixelBuffer) throws {
        do {
            let requestHandler = VNSequenceRequestHandler()
            try requestHandler.perform([detectRectangleRequest], on: buffer)
        } catch {
            print("Couldn't perform rectangle detection request. Error: \(error)")
            throw VisionError.readerInitializationFailed
        }
    }

    func recognizeRectangle(in ciImage: CIImage) throws {
        inputImage = ciImage
        do {
            let requestHandler = VNImageRequestHandler(ciImage: inputImage, options: [:])
            try requestHandler.perform([detectRectangleRequest])
        } catch {
            print("Couldn't perform rectangle detection request. Error: \(error)")
            throw VisionError.readerInitializationFailed
        }
    }

    private func handleRectangles(request: VNRequest, error: Error?) {
        guard
            let observation = request.results?.first,
            let rectangleObservation = observation as? VNRectangleObservation
            else { print("Didn't recognize any rectangles in processed image."); return }

        let imageSize = inputImage.extent.size
        let boundingBox = rectangleObservation.boundingBox.scaled(to: imageSize)

        guard inputImage.extent.contains(boundingBox)
            else { print("invalid detected rectangle"); return }

        let topLeft = rectangleObservation.topLeft.scaled(to: imageSize)
        let topRight = rectangleObservation.topRight.scaled(to: imageSize)
        let bottomLeft = rectangleObservation.bottomLeft.scaled(to: imageSize)
        let bottomRight = rectangleObservation.bottomRight.scaled(to: imageSize)
        let correctedImage = inputImage
            .cropped(to: boundingBox)
            .applyingFilter("CIPerspectiveCorrection", parameters: [
                "inputTopLeft": CIVector(cgPoint: topLeft),
                "inputTopRight": CIVector(cgPoint: topRight),
                "inputBottomLeft": CIVector(cgPoint: bottomLeft),
                "inputBottomRight": CIVector(cgPoint: bottomRight)
                ])
            .applyingFilter("CIUnsharpMask")

        guard let cgImage = context.createCGImage(correctedImage, from: correctedImage.extent) else {
            print("Context failed while creating CGImage."); return }

        finalImage.value = UIImage(cgImage: cgImage)
    }
}
