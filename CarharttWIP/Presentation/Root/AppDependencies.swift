//
//  AppDependencies.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation

/// Only the composition root knows the concrete infrastructure graph.
struct AppDependencies: Sendable {
    let inputDataUseCase: any InputDataUseCaseProtocol
    let recommendationUseCase: RecommendationUseCase

    static func live(bundle: Bundle = .main) -> AppDependencies {
        let local = InputDataLocal(client: LocalClient(bundle: bundle))
        let repository = InputDataRepository(local: local)
        return AppDependencies(
            inputDataUseCase: InputDataUseCase(repository: repository),
            recommendationUseCase: RecommendationUseCase()
        )
    }
}
