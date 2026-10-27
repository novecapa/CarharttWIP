//
//  LocalClient.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

/// Serializes bundled file access away from MainActor.
actor LocalClient: LocalClientProtocol {
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func getData<T: Decodable & Sendable>(type: T.Type, resource: String) async throws -> T {
        try Task.checkCancellation()
        guard let url = bundle.url(forResource: resource, withExtension: "json") else {
            throw LocalClientError.badPath
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw LocalClientError.readError
        }
        try Task.checkCancellation()
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw LocalClientError.decodeError
        }
    }
}
