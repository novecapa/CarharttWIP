//
//  LikeWIPViewBuilder.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

@MainActor
struct LikeWIPViewBuilder {
    func build(dependencies: AppDependencies, router: AppRouter) -> LikeWIPView {
        let interactor = LikeWIPInteractor(useCase: dependencies.inputDataUseCase)
        let viewModel = LikeWIPViewModel(interactor: interactor, router: LikeWIPRouter(app: router))
        return LikeWIPView(viewModel: viewModel)
    }
}
