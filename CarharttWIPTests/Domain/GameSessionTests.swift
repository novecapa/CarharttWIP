//
//  GameSessionTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Testing
@testable import CarharttWIP

struct GameSessionTests {
    @Test(arguments: [0, 1, 4, 10, 15])
    func capsRoundAndPreservesCatalogOrder(count: Int) {
        let items = TestFixtures.items(count)
        let session = GameSession(items: items)
        #expect(session.items == Array(items.prefix(10)))
        #expect(!session.isComplete)
    }

    @Test func removesDuplicatesBeforeApplyingLimit() {
        let items = TestFixtures.items(12)
        let session = GameSession(items: [items[0], items[0]] + items)
        #expect(session.items == Array(items.prefix(10)))
    }

    @Test func rejectsStaleOutOfOrderAndRepeatedReactions() {
        let items = TestFixtures.items(2)
        var session = GameSession(items: items)
        let accepted1 = session.react(to: items[1].id, with: .like)
        #expect(!accepted1)
        let accepted2 = session.react(to: items[0].id, with: .superLike)
        #expect(accepted2)
        let accepted3 = session.react(to: items[0].id, with: .disLike)
        #expect(!accepted3)
        #expect(session.currentItem == items[1])
        let accepted4 = session.react(to: items[1].id, with: .disLike)
        #expect(accepted4)
        #expect(session.isComplete)
        #expect(session.remainingItems.isEmpty)
        let accepted5 = session.react(to: items[1].id, with: .like)
        #expect(!accepted5)
        #expect(session.reactions.map(\.like) == [.superLike, .disLike])
    }

    @Test func emptyCatalogCannotCompleteOrAcceptReactions() {
        var session = GameSession(items: [])
        let accepted6 = session.react(to: "missing", with: .like)
        #expect(!accepted6)
        #expect(!session.isComplete)
    }
}
