//
//  InputDataLocal.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class InputDataLocal {

    // MARK: Private
    private let client: LocalClientProtocol

    // MARK: Init
    init(client: LocalClientProtocol) {
        self.client = client
    }
}

extension InputDataLocal: InputDataLocalProtocol {
    func getItems() async throws -> DataDTO {
        try await client.getData(type: DataDTO.self, resource: "DataDTO")
    }
}
