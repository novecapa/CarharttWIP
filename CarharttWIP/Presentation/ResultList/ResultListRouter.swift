//
//  ResultListRouter.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

@MainActor
struct ResultListRouter {
    let app: AppRouter

    func playAgain() { app.startGame() }
}
