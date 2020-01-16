//
//  GravatarAPI.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 17/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit
import CryptoSwift

typealias AvatarImageCompletion = (UIImage) -> ()

class GravatarAPI: NSObject {

    private override init() {
        // Use the static functions only
    }

    static func emailHash(email: String) -> String {
        return email.trim().lowercased().md5()
    }

    static func avatarUrl(email: String, size: Int) -> URL? {
        let emailHash = GravatarAPI.emailHash(email: email)
        return URL(string: "https://secure.gravatar.com/avatar/\(emailHash).jpg?s=\(size)&d=404")
    }

    static func avatarImage(email: String, size: Int, completion: @escaping AvatarImageCompletion) {
        let imageUrl = GravatarAPI.avatarUrl(email: email, size: size)!

        URLSession.shared.dataTask(with: imageUrl) {
            (data, response, _) in

            guard
                let httpResponse = response as? HTTPURLResponse,
                let data = data,
                let image = UIImage(data: data)
                else { return }

            if (httpResponse.statusCode == 200) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}
