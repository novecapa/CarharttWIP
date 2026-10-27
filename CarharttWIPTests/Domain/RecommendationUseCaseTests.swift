//
//  RecommendationUseCaseTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Testing
@testable import CarharttWIP

struct RecommendationUseCaseTests {
    @Test func filtersDislikesWithoutChangingOrder() {
        let items = TestFixtures.items(3)
        let reactions = zip(items, [LikeType.like, .disLike, .superLike]).map { LikeItem(item: $0, like: $1) }
        #expect(RecommendationUseCase().likedItems(in: reactions) == [reactions[0], reactions[2]])
    }

    @Test func updatesByProductIdentityAndPreservesRoundTotal() {
        let item = TestFixtures.items(1)[0]
        let useCase = RecommendationUseCase()
        let original = [LikeItem(item: item, like: .like)]
        let promoted = useCase.updating(original, itemID: item.id, reaction: .superLike)
        let removed = useCase.updating(promoted, itemID: item.id, reaction: .disLike)
        #expect(promoted.first?.like == .superLike)
        #expect(removed.count == 1)
        #expect(useCase.likedItems(in: removed).isEmpty)
        #expect(useCase.updating(original, itemID: "unknown", reaction: .disLike) == original)
    }
}
