//
//  ItemDTO.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

struct ItemDTO: Codable {
    let title: String
    let image: String
}
extension ItemDTO {
    var toEntity: Item {
        Item(title: title, image: image)
    }
}
