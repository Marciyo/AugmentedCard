//
//  ContactCell.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 28/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    fileprivate func setupView() {
        avatarImage.layer.cornerRadius = avatarImage.frame.width
        avatarImage.layer.shadowColor = UIColor.black.cgColor
        avatarImage.layer.shadowOffset = .init(width: 1, height: 1)
        avatarImage.layer.shadowRadius = 2
        avatarImage.layer.shadowOpacity = 0.8
        avatarImage.backgroundColor = .gray
    }
}

extension ContactCell: NibReusableView { }
