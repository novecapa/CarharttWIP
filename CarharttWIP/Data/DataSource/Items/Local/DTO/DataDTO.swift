//
//  DataDTO.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

struct DataDTO: Codable {
    let items: [ItemDTO]

    enum CodingKeys: String, CodingKey {
        case items = "data"
    }
}
