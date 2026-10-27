//
//  LikeWIPViewModelTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 19/9/24.
//

import Foundation
import Testing
@testable import CarharttWIP

@MainActor
struct LikeWIPViewModelTests {
    private func makeViewModel(repository: any InputDataRepositoryProtocol, router: AppRouter) -> LikeWIPViewModel {
        LikeWIPViewModel(
            interactor: LikeWIPInteractor(useCase: InputDataUseCase(repository: repository)),
            router: LikeWIPRouter(app: router)
        )
    }

    @Test func loadDoesNotNavigateAndRepeatedAppearanceKeepsProgress() async {
        let items = TestFixtures.items(3)
        let router = AppRouter()
        router.startGame()
        let initialRoute = router.screen
        let model = makeViewModel(repository: StubRepository(result: .success(items)), router: router)
        await model.load()
        #expect(model.state.phase == .loaded)
        #expect(model.state.session.currentItem == items[0])
        model.send(.react(itemID: items[0].id, reaction: .like))
        await model.load()
        #expect(model.state.session.reactions.count == 1)
        #expect(router.screen == initialRoute)
    }

    @Test func emptyCatalogIsLoadedWithoutPresentingResults() async {
        let router = AppRouter()
        router.startGame()
        let initialRoute = router.screen
        let model = makeViewModel(repository: StubRepository(result: .success([])), router: router)
        await model.load()
        #expect(model.state.phase == .loaded)
        #expect(model.state.session.items.isEmpty)
        #expect(router.screen == initialRoute)
    }

    @Test func failureExposesMessageAndRetryCanRecover() async {
        let repository = ControlledRepository()
        let router = AppRouter()
        router.startGame()
        let model = makeViewModel(repository: repository, router: router)
        let firstLoad = Task { await model.load() }
        await repository.waitUntilRequested()
        #expect(model.state.phase == .loading)
        await repository.complete(with: .failure(.badPath))
        await firstLoad.value
        #expect(model.state.phase == .failed(LocalClientError.badPath.localizedDescription))
        model.send(.retryTapped)
        #expect(model.state.loadID == 1)
        let secondLoad = Task { await model.load() }
        await repository.waitUntilRequested()
        await repository.complete(with: .success(TestFixtures.items(1)))
        await secondLoad.value
        #expect(model.state.phase == .loaded)
        #expect(model.state.session.items.count == 1)
    }

    @Test func cancellationDiscardsLateDataAndAllowsReload() async {
        let repository = ControlledRepository()
        let model = makeViewModel(repository: repository, router: AppRouter())
        let load = Task { await model.load() }
        await repository.waitUntilRequested()
        await model.load() // An overlapping load is ignored.
        model.send(.retryTapped) // So is a retry while loading.
        #expect(await repository.callCount == 1)
        #expect(model.state.loadID == 0)
        load.cancel()
        await repository.complete(with: .success(TestFixtures.items(3)))
        await load.value
        #expect(model.state.phase == .idle)
        #expect(model.state.session.items.isEmpty)
        let reload = Task { await model.load() }
        await repository.waitUntilRequested()
        await repository.complete(with: .success(TestFixtures.items(1)))
        await reload.value
        #expect(model.state.phase == .loaded)
    }

    @Test func lastReactionNavigatesOnceWithAllReactions() async {
        let items = TestFixtures.items(12)
        let router = AppRouter()
        router.startGame()
        let model = makeViewModel(repository: StubRepository(result: .success(items)), router: router)
        await model.load()
        for item in items.prefix(10) { model.send(.react(itemID: item.id, reaction: .like)) }
        let expected = items.prefix(10).map { LikeItem(item: $0, like: .like) }
        #expect(router.screen == .results(expected))
        model.send(.react(itemID: items[9].id, reaction: .disLike))
        #expect(router.screen == .results(expected))
        #expect(model.state.session.reactions == expected)
    }

    @Test func olderFeedbackCannotHideNewerReaction() async throws {
        let items = TestFixtures.items(3)
        let model = makeViewModel(repository: StubRepository(result: .success(items)), router: AppRouter())
        await model.load()
        model.send(.react(itemID: items[0].id, reaction: .like))
        let first = try #require(model.state.feedback)
        model.send(.react(itemID: items[1].id, reaction: .superLike))
        let second = try #require(model.state.feedback)
        model.send(.feedbackExpired(first.id))
        #expect(model.state.feedback == second)
        model.send(.feedbackExpired(second.id))
        #expect(model.state.feedback == nil)
    }

    @Test func closeReturnsHome() {
        let router = AppRouter()
        router.startGame()
        let model = makeViewModel(repository: StubRepository(result: .success([])), router: router)
        model.send(.closeTapped)
        #expect(router.screen == .home)
    }
}
