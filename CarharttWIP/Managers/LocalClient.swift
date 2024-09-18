//
//  LocalClient.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class LocalClient: LocalClientProtocol {

    private enum Constants {
        static let jsonExt = "json"
    }

    func getData<T>(type: T.Type) throws -> T where T : Decodable {
        let fileName = "\(T.self)"
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
