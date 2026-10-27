//
//  LocalClientError.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

enum LocalClientError: LocalizedError, Equatable {
    case badPath
    case readError
    case decodeError

    var errorDescription: String? {
        switch self {
        case .badPath: String(localized: "The product catalog could not be found.")
        case .readError: String(localized: "The product catalog could not be opened.")
        case .decodeError: String(localized: "The product catalog has an invalid format.")
        }
    }
}
