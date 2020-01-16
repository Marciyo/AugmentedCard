//
//  ImageCache.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 24/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL) {
        if let image = getCached(image: url) {
            self.image = image
        } else {
            download(image: url)
        }
    }

    private func download(image url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (rawImage, response, error) in
            DispatchQueue.main.async {
                if let rawImage = rawImage {
                    self?.image = UIImage(data: rawImage, scale: 1)
                    self?.save(image: url, rawImage: rawImage)
                }
            }
            }.resume()
    }

    private func save(image url: URL, rawImage: Data?) {
        let path = getFilePath(from: url)
        FileManager.default.createFile(atPath: path, contents: rawImage, attributes: nil)
    }

    private func getCached(image url: URL) -> UIImage? {
        let path = getFilePath(from: url)
        guard let data = FileManager.default.contents(atPath: path) else { return nil }
        return UIImage(data: data, scale: 1)
    }

    private func getFilePath(from url: URL) -> String {
        let destination = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/")
        let fileName = (url.absoluteString as NSString).lastPathComponent
        return destination.appending(fileName)
    }
}
