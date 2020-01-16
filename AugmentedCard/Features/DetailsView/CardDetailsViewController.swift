//
//  CardDetailsViewController.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {

    @IBOutlet weak var pictureContainer: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    private func setupView() {

        let pictureController = CDPictureViewController()
        addChild(pictureController)
        pictureContainer.addSubview(pictureController.view)
        pictureController.didMove(toParent: self)

        let collectionController = CDCollectionViewController()
        addChild(collectionController)
        collectionContainer.addSubview(collectionController.view)
        collectionController.didMove(toParent: self)
    }

}
