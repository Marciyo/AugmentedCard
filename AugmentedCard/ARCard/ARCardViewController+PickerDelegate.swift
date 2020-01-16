//
//  ARCardViewController+PickerDelegate.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

extension ARCardViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        do {
            try self.viewModel.visionManager.recognizeRectangle(in: getPickerImage(from: info))
            dismiss(animated: true) {
                // For debugging purposes only
                self.imagePreview.image = self.viewModel.visionManager.finalImage.value
            }
        } catch {
            #warning("TODO : -Better error handling - possibly show alerts to user.")
            print(error)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    private func getPickerImage(from info: [UIImagePickerController.InfoKey : Any]) -> CIImage {
        guard
            let croppedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
            let ciImage = CIImage(image: croppedImage),
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(croppedImage.imageOrientation.rawValue))
            else {
                fatalError("Couldn't read cropped photo with orientation from picker.")
        }
        return ciImage.oriented(orientation)
    }
}
