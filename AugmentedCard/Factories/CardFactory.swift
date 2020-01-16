//
//  CardFactory.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 17/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Foundation
import NaturalLanguage
import FirebaseMLVision

class CardFactory {
    private let nlpManager = NLPManager()

    private struct RegExPatterns {
        static let Email = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}"
        static let WebPage = "\\b[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let Phone = "[+]?([ ]*[0-9][ ]*){9,20}"
        static let Twitter = "\\B@[a-z0-9]*"
    }

    func createCard(visionData: VisionText) -> Card {
        print("Input text: \(visionData.text)")
        let tags = nlpManager.findTags(text: visionData.text)
        var name = String(visionData.text[tags.firstRange(matching: .personalName) ?? visionData.text.startIndex..<visionData.text.startIndex])
        var company = String(visionData.text[tags.firstRange(matching: .organizationName) ?? visionData.text.startIndex..<visionData.text.startIndex])
        var phone = String(visionData.text[tags.firstRange(matching: .number) ?? visionData.text.startIndex..<visionData.text.startIndex])
        let email = nlpManager.findString(text: visionData.text, matchingRegEx: RegExPatterns.Email)
        let webPage = nlpManager.findString(text: visionData.text, matchingRegEx: RegExPatterns.WebPage)
        let twitter = nlpManager.findString(text: visionData.text, matchingRegEx: RegExPatterns.Twitter)

        if phone.isEmpty {
            phone = nlpManager.findString(text: visionData.text, matchingRegEx: RegExPatterns.Phone)
        }
        if name.isEmpty, let names = email.split(separator: "@").first?.description {
            name = names.replacingOccurrences(of: ".", with: " ")
        }
        if company.isEmpty && !email.isEmpty {
            let domain = email.split(separator: "@")[1].description
            company = domain.replacingOccurrences(of: ".", with: " ")
        }
        let card = Card(phoneNumber: phone, email: email, name: name,
                        twitter: twitter, webpage: webPage, company: company)
        print("Output card: \(card)")
        return card
    }
}
