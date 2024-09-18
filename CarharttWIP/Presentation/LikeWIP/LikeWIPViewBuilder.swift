//
//  LikeWIPViewBuilder.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class LikeWIPViewBuilder {
    func build() -> LikeWIPView {
        let localClient: LocalClientProtocol = LocalClient()
        let dataLocal: InputDataLocalProtocol = InputDataLocal(client: localClient)
        let repository: InputDataRepositoryProtocol = InputDataRepository(local: dataLocal)
        let useCase: InputDataUseCaseProtocol = InputDataUseCase(repository: repository)
        let viewModel = LikeWIPViewModel(useCase: useCase)
        let view = LikeWIPView(viewModel: viewModel)
        return view
    }
}
