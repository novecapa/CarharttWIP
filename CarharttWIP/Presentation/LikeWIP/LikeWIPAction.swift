//
//  LikeWIPAction.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation

enum LikeWIPAction {
    case react(itemID: Item.ID, reaction: LikeType)
    case retryTapped
    case closeTapped
    case feedbackExpired(UUID)
}
