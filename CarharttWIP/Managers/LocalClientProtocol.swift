//
//  LocalClientProtocol.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

protocol LocalClientProtocol {
    func getData<T: Decodable>(type: T.Type) throws -> T
}
