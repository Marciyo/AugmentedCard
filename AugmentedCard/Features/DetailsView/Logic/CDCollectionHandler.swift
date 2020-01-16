//
//  CDCollectionHandler.swift
//  AugmentedCard
//
//  Created by Artur Chabera on 25/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit

class CDCollectionHandler: NSObject {

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

    override init() {
        super.init()
    }

}

extension CDCollectionHandler: UITableViewDataSource {
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

extension CDCollectionHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
