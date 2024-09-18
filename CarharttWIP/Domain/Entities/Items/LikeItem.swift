//
//  LikeItem.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

enum LikeType: String {
    case like
    case superLike
    case disLike
    case none
}

struct LikeItem: Hashable {
    let item: Item
    var like: LikeType
}
