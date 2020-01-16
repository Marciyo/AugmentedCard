//
//  CardDetailsMemo.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import Foundation

enum MemoType: String {
    case voice = "🎙"
    case todo = "✅"
    case calendar = "📆"
    case note = "📝"
}

struct CardDetailsMemo {
    var memoType: MemoType
    var title: String
    var memo: String
}
