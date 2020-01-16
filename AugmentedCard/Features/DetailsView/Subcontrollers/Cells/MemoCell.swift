//
//  MemoCell.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var memo: CardDetailsMemo! {
        didSet {
            iconLabel.text = memo.memoType.rawValue
            titleLabel.text = memo.title
            closeLabel.text = "X"
            descLabel.text = memo.memo
            descLabel.isHidden = memo.memo.isEmpty
        }
    }
}

extension MemoCell: NibReusableView { }
