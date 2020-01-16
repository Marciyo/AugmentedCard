//
//  Card.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 16/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Foundation

struct Card: Hashable {
    let phoneNumber: String
    let email: String
    let name: String
    let twitter: String
    let company: String
    let webpage: URL?

    init(phoneNumber: String, email: String, name: String, twitter: String, webpage: String, company: String) {
        self.phoneNumber = phoneNumber.trim()
        self.email = email
        self.name = name
        self.twitter = twitter
        self.webpage = URL(string: webpage)
        self.company = company
    }
}
