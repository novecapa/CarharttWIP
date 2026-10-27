//
//  SwipeReaction.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation

/// Gesture policy belongs to Presentation; Domain only receives an intentional reaction.
enum SwipeReaction {
    static let threshold: CGFloat = 250

    static func reaction(for translation: CGSize) -> LikeType? {
        // Reject downward and short gestures without consuming a product.
        guard translation.height < 50 else { return nil }
        if translation.height < -threshold { return .superLike }
        if translation.width < -threshold { return .disLike }
        if translation.width > threshold { return .like }
        return nil
    }
}
