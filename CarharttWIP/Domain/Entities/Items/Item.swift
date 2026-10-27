//
//  Item.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

struct Item: Identifiable, Hashable, Sendable {
    // The bundled catalog has no product ID; its image URL is its unique, stable key.
    var id: String { image }
    let title: String
    let image: String
}
