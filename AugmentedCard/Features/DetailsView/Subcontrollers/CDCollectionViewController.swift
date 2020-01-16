//
//  CDCollectionViewController.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class CDCollectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let actions: [CardDetailsAction] = [
        CardDetailsAction(icon: "📞", title: "0048 000 111 222"),
        CardDetailsAction(icon: "✉️", title: "john.snowdog@gmail.com"),
        CardDetailsAction(icon: "📝", title: "ADD NOTE"),
        CardDetailsAction(icon: "🎙", title: "ADD VOICE MEMO")
    ]

    let memos: [CardDetailsMemo] = [
        CardDetailsMemo(memoType: .note, title: "Conversation", memo: "We talked about possibility of using AR technologies to create managing contacts app"),
        CardDetailsMemo(memoType: .voice, title: "Ideas for app name", memo: ""),
        CardDetailsMemo(memoType: .calendar, title: "Meeting", memo: "Business lunch @Yetz-tu"),
        CardDetailsMemo(memoType: .todo, title: "Storyboards", memo: "Remember about storyboards on desk"),
        ]


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(MemoCell.self)
        tableView.register(ActionCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.sectionHeaderHeight = 8
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        tableView.allowsSelection = false
    }

    
}

extension CDCollectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return actions.count
        default:
            return memos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell: ActionCell = tableView.dequeueReusableCell(for: indexPath)
            cell.action = actions[indexPath.row]
            return cell
        default:
            let cell: MemoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.memo = memos[indexPath.row]
            return cell
        }
    }
}
