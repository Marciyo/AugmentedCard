//
//  GoogleSearchManager.swift
//  PromiseKitAPI
//
//  Created by Artur Chabera on 23/01/2019.
//  Copyright © 2019 Artur Chabera. All rights reserved.
//

import Foundation
import UIKit

enum SearchManagerError: Error {
    case imageConversionFailed
}

protocol GoogleSearchManager {
    func searchUser(with parameters: [String], completion: @escaping (GoogleImage?, Error?) -> ())
}

class RemoteGoogleSearchManager: GoogleSearchManager {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func searchUser(with parameters: [String], completion: @escaping (GoogleImage?, Error?) -> ()) {
        let request = GoogleSearchCall(query: parameters)
        session.dataTask(with: request, decoder: decoder) { (googleImage: GoogleImage?, response, error) in
            DispatchQueue.main.async {
                completion(googleImage, error)
            }
            }.resume()
    }

    func download(image url: URL, completion: @escaping (Result<UIImage>) -> ()) {
        session.dataTask(with: url) { (rawImage, response, error) in
            DispatchQueue.main.async {
                if
                    let rawImage = rawImage,
                    let image = UIImage(data: rawImage, scale: 1) {
                    completion(.success(image))
                } else {
                    completion(.failure(error ?? SearchManagerError.imageConversionFailed))
                }
            }
            }.resume()
    }
}
