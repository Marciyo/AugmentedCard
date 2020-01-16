//
//  ActionCell.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var action: CardDetailsAction! {
        didSet {
            iconLabel.text = action.icon
            titleLabel.text = action.title
        }
    }
}

extension ActionCell: NibReusableView { }
