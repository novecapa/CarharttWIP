//
//  AppRouterTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Testing
@testable import CarharttWIP

@MainActor
struct AppRouterTests {
    @Test func cannotPresentEmptyOrOutOfContextResults() {
        let router = AppRouter()
        let reactions = TestFixtures.items(1).map { LikeItem(item: $0, like: .like) }
        router.showResults(reactions)
        #expect(router.screen == .home)
        router.startGame()
        let round = router.screen
        router.showResults([])
        #expect(router.screen == round)
        router.closeGame()
        #expect(router.screen == .home)
    }
}
