//
//  String+Extensions.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }

    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
