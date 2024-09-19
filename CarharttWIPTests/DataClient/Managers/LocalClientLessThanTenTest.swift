//
//  LocalClientLessThanTenTest.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 19/9/24.
//

import Foundation
@testable import CarharttWIP

final class LocalClientLessThanTenTest: LocalClientProtocol {

    private enum Constants {
        static let jsonExt = "json"
    }

    func getData<T>(type: T.Type) throws -> T where T : Decodable {
        let fileName = "DataLessTahnTenDTO"
        guard let url = Bundle.main.url(forResource: fileName,
                                        withExtension: Constants.jsonExt) else {
            throw LocalClientError.badPath
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw LocalClientError.decodeError
        }
    }
}
