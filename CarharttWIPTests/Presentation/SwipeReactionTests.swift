//
//  SwipeReactionTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation
import Testing
@testable import CarharttWIP

struct SwipeReactionTests {
    @Test func acceptsDirectionalGestures() {
        #expect(SwipeReaction.reaction(for: CGSize(width: -300, height: 0)) == .disLike)
        #expect(SwipeReaction.reaction(for: CGSize(width: 300, height: 0)) == .like)
        #expect(SwipeReaction.reaction(for: CGSize(width: 0, height: -300)) == .superLike)
        #expect(SwipeReaction.reaction(for: CGSize(width: 300, height: -300)) == .superLike)
    }

    @Test func rejectsDownwardShortAndThresholdGestures() {
        #expect(SwipeReaction.reaction(for: .zero) == nil)
        #expect(SwipeReaction.reaction(for: CGSize(width: 300, height: 100)) == nil)
        #expect(SwipeReaction.reaction(for: CGSize(width: 0, height: 400)) == nil)
        #expect(SwipeReaction.reaction(for: CGSize(width: 250, height: 0)) == nil)
        #expect(SwipeReaction.reaction(for: CGSize(width: 0, height: -250)) == nil)
    }
}
