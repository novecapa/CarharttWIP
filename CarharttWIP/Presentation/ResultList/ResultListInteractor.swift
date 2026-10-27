//
//  ResultListInteractor.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

struct ResultListInteractor {
    let useCase: RecommendationUseCase

    func likedItems(in reactions: [LikeItem]) -> [LikeItem] {
        useCase.likedItems(in: reactions)
    }

    func updating(_ reactions: [LikeItem], itemID: Item.ID, reaction: LikeType) -> [LikeItem] {
        useCase.updating(reactions, itemID: itemID, reaction: reaction)
    }
}
