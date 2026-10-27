//
//  SceneFactory.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import SwiftUI

@MainActor
struct SceneFactory {
    let dependencies: AppDependencies
    let router: AppRouter

    @ViewBuilder
    func view(for screen: AppRouter.Screen) -> some View {
        switch screen {
        case .home:
            GameView(onStart: router.startGame)
        case .game(let roundID):
            LikeWIPViewBuilder().build(dependencies: dependencies, router: router)
                .id(roundID)
        case .results(let reactions):
            ResultListViewBuilder().build(reactions, dependencies: dependencies, router: router)
        }
    }
}
