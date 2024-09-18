//
//  InputDataRepositoryProtocol.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

protocol InputDataRepositoryProtocol {
    func getData() throws -> [Item]
}
