//
//  LikeWIPRouter.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

@MainActor
struct LikeWIPRouter {
    let app: AppRouter

    func showResults(_ reactions: [LikeItem]) { app.showResults(reactions) }
    func close() { app.closeGame() }
}
