//
//  ResultListViewModelTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/9/24.
//

import Testing
@testable import CarharttWIP

@MainActor
struct ResultListViewModelTests {
    private func model(_ reactions: [LikeItem], router: AppRouter = AppRouter()) -> ResultListViewModel {
        ResultListViewModel(
            reactions: reactions,
            interactor: ResultListInteractor(useCase: RecommendationUseCase()),
            router: ResultListRouter(app: router)
        )
    }

    @Test func editsAreAppliedByIDAfterPreviousEdits() {
        let item = TestFixtures.items(1)[0]
        let model = model([LikeItem(item: item, like: .like)])
        model.send(.changeReaction(itemID: item.id, reaction: .superLike))
        #expect(model.likedItems.first?.like == .superLike)
        model.send(.changeReaction(itemID: item.id, reaction: .disLike))
        #expect(model.likedItems.isEmpty)
        #expect(model.state.reactions.count == 1)
    }

    @Test func emptySelectionCannotShowCartFeedback() {
        let model = model([])
        model.send(.addToCartTapped)
        #expect(model.state.toast == nil)
    }

    @Test func toastSnapshotsCountAndIgnoresExpiredPreviousToast() throws {
        let items = TestFixtures.items(2)
        let model = model(items.map { LikeItem(item: $0, like: .like) })
        model.send(.addToCartTapped)
        let first = try #require(model.state.toast)
        model.send(.changeReaction(itemID: items[0].id, reaction: .disLike))
        #expect(model.state.toast?.itemCount == 2)
        model.send(.addToCartTapped)
        let second = try #require(model.state.toast)
        #expect(second.itemCount == 1)
        model.send(.toastExpired(first.id))
        #expect(model.state.toast == second)
        model.send(.toastExpired(second.id))
        #expect(model.state.toast == nil)
    }

    @Test func closingResultsStartsANewRound() {
        let router = AppRouter()
        router.startGame()
        let previousRound = router.screen
        let reactions = TestFixtures.items(1).map { LikeItem(item: $0, like: .like) }
        router.showResults(reactions)
        model(reactions, router: router).send(.closeTapped)
        guard case .game = router.screen else {
            Issue.record("Expected a new game")
            return
        }
        #expect(router.screen != previousRound)
    }
}
