//
//  LikeWIPInteractor.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

struct LikeWIPInteractor {
    let useCase: any InputDataUseCaseProtocol

    func loadSession() async throws -> GameSession {
        GameSession(items: try await useCase.getItems())
    }
}
