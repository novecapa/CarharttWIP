//
//  InputDataUseCaseProtocol.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

protocol InputDataUseCaseProtocol {
    func getItems() throws -> [Item]
}
