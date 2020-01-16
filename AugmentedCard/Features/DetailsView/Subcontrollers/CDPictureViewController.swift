//
//  CDPictureViewController.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class CDPictureViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.height/2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.image = UIImage(named: "husky")
        profilePictureImageView.contentMode = .scaleAspectFill
        profilePictureImageView.layer.borderColor = UIColor.darkGray.cgColor
        profilePictureImageView.layer.borderWidth = 1.0

        nameLabel.text = "John Snowdog"
        positionLabel.text = "Developer"
        companyNameLabel.text = "SNOW.DOG"
    }

}
