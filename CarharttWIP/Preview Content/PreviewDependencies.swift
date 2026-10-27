//
//  PreviewDependencies.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

#if DEBUG
import Foundation

extension AppDependencies {
    static func preview(items: [Item] = [LikeItem].mockItemsRandom.map(\.item)) -> AppDependencies {
        AppDependencies(
            inputDataUseCase: InputDataUseCase(repository: PreviewRepository(items: items)),
            recommendationUseCase: RecommendationUseCase()
        )
    }
}

private struct PreviewRepository: InputDataRepositoryProtocol {
    let items: [Item]
    func getData() async throws -> [Item] { items }
}
#endif
