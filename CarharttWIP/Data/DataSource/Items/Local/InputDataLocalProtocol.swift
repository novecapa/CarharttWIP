//
//  InputDataLocalProtocol.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

protocol InputDataLocalProtocol: Sendable {
    func getItems() async throws -> DataDTO
}
