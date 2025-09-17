//
//  InputDataRepository.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class InputDataRepository {

    // MARK: Private
    private let local: InputDataLocalProtocol

    // MARK: Init
    init(local: InputDataLocalProtocol) {
        self.local = local
    }
}

extension InputDataRepository: InputDataRepositoryProtocol {
    func getData() throws -> [Item] {
        try local.getItems().items.map { $0.toEntity }
    }
}
