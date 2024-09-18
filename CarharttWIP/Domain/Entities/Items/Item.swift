//
//  Item.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

struct Item: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let image: String
}
