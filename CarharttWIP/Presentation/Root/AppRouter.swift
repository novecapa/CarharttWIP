//
//  AppRouter.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation
import Observation

/// One owner for the three full-screen destinations. Every replay gets a fresh identity.
@MainActor
@Observable
final class AppRouter {
    enum Screen: Equatable {
        case home
        case game(UUID)
        case results([LikeItem])
    }

    private(set) var screen: Screen = .home

    func startGame() { screen = .game(UUID()) }
    func closeGame() { screen = .home }

    func showResults(_ reactions: [LikeItem]) {
        guard case .game = screen, !reactions.isEmpty else { return }
        screen = .results(reactions)
    }
}
