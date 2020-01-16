//
//  Dynamic.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 23/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}
