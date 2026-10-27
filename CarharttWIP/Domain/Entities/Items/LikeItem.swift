//
//  LikeItem.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

enum LikeType: String, Sendable {
    case like
    case superLike
    case disLike
}

struct LikeItem: Hashable, Sendable {
    let item: Item
    var like: LikeType
}
