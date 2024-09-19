//
//  LocalClientBadRequestTest.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 19/9/24.
//

import Foundation

import Foundation
@testable import CarharttWIP

final class LocalClientBadPathTest: LocalClientProtocol {

    func getData<T>(type: T.Type) throws -> T where T : Decodable {
        throw LocalClientError.badPath
    }
}
