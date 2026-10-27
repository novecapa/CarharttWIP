//
//  ResultListViewModel.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation
import Observation

@MainActor
@Observable
final class ResultListViewModel {
    struct Toast: Equatable {
        let id = UUID()
        let itemCount: Int
    }

    struct State {
        var reactions: [LikeItem]
        var toast: Toast?
    }

    private(set) var state: State
    private let interactor: ResultListInteractor
    private let router: ResultListRouter

    init(reactions: [LikeItem], interactor: ResultListInteractor, router: ResultListRouter) {
        state = State(reactions: reactions)
        self.interactor = interactor
        self.router = router
    }

    var likedItems: [LikeItem] { interactor.likedItems(in: state.reactions) }

    func send(_ action: ResultListAction) {
        switch action {
        case .changeReaction(let id, let reaction):
            state.reactions = interactor.updating(state.reactions, itemID: id, reaction: reaction)
        case .addToCartTapped:
            guard !likedItems.isEmpty else { return }
            // Demo feedback only. There is deliberately no checkout or persistence.
            state.toast = Toast(itemCount: likedItems.count)
        case .toastExpired(let id):
            guard state.toast?.id == id else { return }
            state.toast = nil
        case .closeTapped:
            router.playAgain()
        }
    }
}
