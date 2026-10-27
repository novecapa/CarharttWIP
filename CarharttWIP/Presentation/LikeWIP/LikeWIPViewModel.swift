//
//  LikeWIPViewModel.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation
import Observation

@MainActor
@Observable
final class LikeWIPViewModel {
    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    struct Feedback: Equatable {
        let id = UUID()
        let reaction: LikeType
    }

    struct State {
        var phase: Phase = .idle
        var session = GameSession(items: [])
        var loadID = 0
        var feedback: Feedback?
    }

    private(set) var state = State()
    private let interactor: LikeWIPInteractor
    private let router: LikeWIPRouter

    init(interactor: LikeWIPInteractor, router: LikeWIPRouter) {
        self.interactor = interactor
        self.router = router
    }

    func load() async {
        guard state.phase == .idle else { return }
        state.phase = .loading
        do {
            let session = try await interactor.loadSession()
            try Task.checkCancellation()
            state.session = session
            state.phase = .loaded
        } catch {
            if Task.isCancelled || error is CancellationError {
                state.phase = .idle
            } else {
                state.phase = .failed(error.localizedDescription)
            }
        }
    }

    func send(_ action: LikeWIPAction) {
        switch action {
        case .react(let itemID, let reaction):
            guard state.phase == .loaded,
                  state.session.react(to: itemID, with: reaction) else { return }
            state.feedback = Feedback(reaction: reaction)
            if state.session.isComplete { router.showResults(state.session.reactions) }
        case .retryTapped:
            guard state.phase != .loading else { return }
            state = State(loadID: state.loadID + 1)
        case .closeTapped:
            router.close()
        case .feedbackExpired(let id):
            guard state.feedback?.id == id else { return }
            state.feedback = nil
        }
    }
}
