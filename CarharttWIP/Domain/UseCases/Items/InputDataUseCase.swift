//
//  InputDataUseCase.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class InputDataUseCase {

    private let repository: InputDataRepositoryProtocol
    init(repository: InputDataRepositoryProtocol) {
        self.repository = repository
    }
}
extension InputDataUseCase: InputDataUseCaseProtocol {
    func getItems() throws -> [Item] {
        try repository.getData()
    }
}
