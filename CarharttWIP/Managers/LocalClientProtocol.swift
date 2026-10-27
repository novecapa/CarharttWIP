//
//  LocalClientProtocol.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

protocol LocalClientProtocol: Sendable {
    func getData<T: Decodable & Sendable>(type: T.Type, resource: String) async throws -> T
}
