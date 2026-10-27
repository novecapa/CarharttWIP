//
//  GameSession.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation

/// A round contains at most ten distinct products, in catalog order.
/// Only the current product can receive a reaction, exactly once.
struct GameSession: Equatable, Sendable {
    static let maximumItems = 10

    let items: [Item]
    private(set) var reactions: [LikeItem] = []

    init(items: [Item]) {
        var seen = Set<Item.ID>()
        self.items = Array(items.filter { seen.insert($0.id).inserted }.prefix(Self.maximumItems))
    }

    var remainingItems: [Item] { Array(items.dropFirst(reactions.count)) }
    var currentItem: Item? { remainingItems.first }
    var isComplete: Bool { !items.isEmpty && reactions.count == items.count }

    @discardableResult
    mutating func react(to itemID: Item.ID, with reaction: LikeType) -> Bool {
        guard let item = currentItem, item.id == itemID else { return false }
        reactions.append(LikeItem(item: item, like: reaction))
        return true
    }
}
