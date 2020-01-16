//
//  ARCardViewModel.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 16/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ARCardViewModel {
    typealias ImageCompletion = (UIImage) -> Void

    let ocrManager = FirebaseOCRManager()
    let visionManager = VisionManager()
    let sceneFactory = SceneFactory()
    private let cardFactory = CardFactory()
    private let googleImageManager = RemoteGoogleSearchManager(session: URLSession.shared, decoder: JSONDecoder())

    var trackedCard = Dynamic<Card?>(nil)
    var trackedCardSize: CGSize!

    var phoneUrl: URL? {
        let cleanPhoneNumber = trackedCard.value?.phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let urlString: String = "tel://\(String(describing: cleanPhoneNumber))"
        return URL(string: urlString)
    }

    func googleSearchForImages(completion: @escaping ImageCompletion) {
        let queries: [String] = [trackedCard.value?.name ?? "", trackedCard.value?.company ?? ""]
        print("Searching google for images with query: \(queries.debugDescription)")
        googleImageManager.searchUser(with: queries) { (gImage, _) in
            let urlStrings = gImage?.items.compactMap { $0.photoUrl }
            let urls = urlStrings?.compactMap { URL(string: $0) }
            self.downloadImage(from: urls) { (userAvatar) in
                completion(userAvatar)
            }
        }
    }

    func downloadImage(from urls: [URL]?, completion: @escaping ImageCompletion) {
        guard var urls = urls, !urls.isEmpty else { print("No URLs for avatar found in search."); return }
        print(urls.debugDescription)
        
        if let firstURL = urls.first {
            print("Downloading image from: \(firstURL.absoluteString)")
            googleImageManager.download(image: firstURL, completion: { (image) in
                do {
                    let image = try image.resolve()
                    completion(image)
                } catch {
                    print("Could not download the image. Error: \(error)")
                    urls.removeFirst()
                    self.downloadImage(from: urls, completion: completion)
                }
            })
        } else {
            print("Could not download any images from provided urls")
        }
    }

    func createCard(fromText visionText: VisionText) {
        trackedCard.value = cardFactory.createCard(visionData: visionText)
    }
}
