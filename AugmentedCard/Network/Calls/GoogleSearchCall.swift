//
//  GoogleSearchCall.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 24/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Foundation

struct GoogleSearchCall: Request {
    var url: URL { return URL(string: baseURLString + "/customsearch/v1")! }
    var method: HTTPMethod { return .get }
    var headers: [String : String]? { return nil }

    var parameters: [String : String]? {
        return [
            "key": apiKey,
            "imgColorType": "color",
            "q": query.joined(separator: " "),
            "cx": "004588976561262178353:j6_hlnau1rk",
//            "imgType": "face"
        ]
    }

    private let query: [String]
    init(query: [String]) {
        self.query = query
    }
}
