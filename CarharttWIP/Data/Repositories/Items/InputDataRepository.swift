//
//  InputDataRepository.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class InputDataRepository {

    private let local: InputDataLocalProtocol
    init(local: InputDataLocalProtocol) {
        self.local = local
    }
}
extension InputDataRepository: InputDataRepositoryProtocol {
    func getData() throws -> [Item] {
        try local.getItems().items.map { $0.toEntity }
    }
}
