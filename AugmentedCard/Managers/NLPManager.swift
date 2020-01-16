//
//  NLPManager.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 22/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import NaturalLanguage

typealias TagAndRange = (tag: NLTag?, range: Range<String.Index>)

extension Array where Element == TagAndRange {
    func firstRange(matching tag: NLTag) -> Range<String.Index>? {
        return first { $0.tag == tag }?.range
    }
}

final class NLPManager {
    private let detector = NLTagger(tagSchemes: [.nameType])

    func findTags(text: String) -> [TagAndRange] {
        detector.string = text
        return detector.tags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: [
                .joinNames,
                .omitPunctuation,
                .omitWhitespace,
                .omitOther,
                ]
        )
    }

    func findString(text: String, matchingRegEx: String) -> String {
        let regex = try? NSRegularExpression(pattern: matchingRegEx, options: .caseInsensitive)
        var range = Range(NSRange(location: 0, length: 0), in: text)
        regex?.firstMatch(in: text, options: [], range: text.range()).flatMap {
            range = Range($0.range, in: text)
        }
        return(String(text[range!]))
    }
}
