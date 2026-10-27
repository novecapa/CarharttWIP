//
//  ResultListAction.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation

enum ResultListAction {
    case changeReaction(itemID: Item.ID, reaction: LikeType)
    case addToCartTapped
    case toastExpired(UUID)
    case closeTapped
}
