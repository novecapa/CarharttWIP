//
//  RecommendationUseCase.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

/// Rules for the editable recommendation list. Dislikes remain in the round's total.
struct RecommendationUseCase: Sendable {
    func likedItems(in reactions: [LikeItem]) -> [LikeItem] {
        reactions.filter { $0.like == .like || $0.like == .superLike }
    }

    func updating(_ reactions: [LikeItem], itemID: Item.ID, reaction: LikeType) -> [LikeItem] {
        reactions.map { entry in
            entry.item.id == itemID ? LikeItem(item: entry.item, like: reaction) : entry
        }
    }
}
