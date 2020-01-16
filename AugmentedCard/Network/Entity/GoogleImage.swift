//
//  GoogleImage.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 24/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Foundation

struct GoogleImage: Decodable {
    let items: [GoogleImageItems]
}

struct GoogleImageItems: Decodable {
    var displayLink: String
    private var pagemap: GoogleImagePageMap
}

extension GoogleImageItems {
    var photoUrl: String? {
        return pagemap.cse_image?.first?.src
    }
}

struct GoogleImagePageMap: Decodable {
    var cse_image: [GoogleImageItemURL]?
}

struct GoogleImageItemURL: Decodable {
    var src: String?
}
