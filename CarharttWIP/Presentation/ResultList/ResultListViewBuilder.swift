//
//  ResultListViewBuilder.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

@MainActor
struct ResultListViewBuilder {
    func build(_ reactions: [LikeItem], dependencies: AppDependencies, router: AppRouter) -> ResultListView {
        let interactor = ResultListInteractor(useCase: dependencies.recommendationUseCase)
        let viewModel = ResultListViewModel(
            reactions: reactions, interactor: interactor, router: ResultListRouter(app: router)
        )
        return ResultListView(viewModel: viewModel)
    }
}
