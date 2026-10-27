//
//  LikeWIPView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct LikeWIPView: View {
    @State var viewModel: LikeWIPViewModel
    @GestureState private var translation: CGSize = .zero

    var body: some View {
        VStack {
            HStack {
                Text("Discover articles for you")
                    .font(.subheadline)
                Spacer()
                Button {
                    viewModel.send(.closeTapped)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Close")
                .accessibilityIdentifier("game.close")
            }
            .padding()
            switch viewModel.state.phase {
            case .idle, .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .failed(let message):
                ContentUnavailableView {
                    Label("Unable to load products", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try again") { viewModel.send(.retryTapped) }
                }
            case .loaded:
                if viewModel.state.session.items.isEmpty {
                    ContentUnavailableView {
                        Label("No products available", systemImage: "tshirt")
                    } actions: {
                        Button("Try again") { viewModel.send(.retryTapped) }
                    }
                } else {
                    cards
                }
            }
        }
        .task(id: viewModel.state.loadID) { await viewModel.load() }
        .task(id: viewModel.state.feedback?.id) {
            guard let id = viewModel.state.feedback?.id else { return }
            do { try await Task.sleep(for: .seconds(1.25)) } catch { return }
            viewModel.send(.feedbackExpired(id))
        }
    }

    private var cards: some View {
        VStack {
            ZStack {
                ForEach(viewModel.state.session.remainingItems.reversed()) { item in
                    let isCurrent = item.id == viewModel.state.session.currentItem?.id
                    CardView(imageName: item.image)
                        .background(.background)
                        .offset(isCurrent ? translation : .zero)
                        .rotationEffect(.degrees(isCurrent ? translation.width / 20 : 0))
                        .allowsHitTesting(isCurrent)
                        .accessibilityHidden(!isCurrent)
                        .accessibilityLabel(item.title)
                        .accessibilityIdentifier(isCurrent ? "game.currentCard" : "game.card")
                        .gesture(
                            DragGesture()
                                .updating($translation) { gesture, value, _ in
                                    guard gesture.translation.height < 50 else { return }
                                    value = gesture.translation
                                }
                                .onEnded { gesture in
                                    guard let reaction = SwipeReaction.reaction(for: gesture.translation) else { return }
                                    viewModel.send(.react(itemID: item.id, reaction: reaction))
                                }
                        )
                }
                if let feedback = viewModel.state.feedback {
                    Image(feedback.reaction.rawValue)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.primary)
                        .frame(width: 60, height: 60)
                        .padding(16)
                        .background(.background, in: RoundedRectangle(cornerRadius: 30))
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
            .animation(.easeInOut, value: translation)

            if let item = viewModel.state.session.currentItem {
                Text(item.title.capitalizingFirstLetter())
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                // Buttons provide the same actions for VoiceOver and users who cannot swipe.
                HStack(spacing: 32) {
                    reactionButton("Dislike", image: .disLike, reaction: .disLike, item: item)
                    reactionButton("Superlike", image: .superLike, reaction: .superLike, item: item)
                    reactionButton("Like", image: .like, reaction: .like, item: item)
                }
            }
            Text("React to \(viewModel.state.session.remainingItems.count) articles")
                .font(.caption)
                .padding()
                .accessibilityIdentifier("game.remaining")
        }
    }

    private func reactionButton(
        _ title: LocalizedStringKey, image: ImageResource, reaction: LikeType, item: Item
    ) -> some View {
        Button {
            viewModel.send(.react(itemID: item.id, reaction: reaction))
        } label: {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.primary)
                .frame(width: 28, height: 28)
                .frame(width: 44, height: 44)
        }
        .accessibilityLabel(title)
        .accessibilityIdentifier("game.\(reaction.rawValue)")
    }
}

#if DEBUG
#Preview {
    LikeWIPViewBuilder().build(dependencies: .preview(), router: AppRouter())
}
#Preview("Empty") {
    LikeWIPViewBuilder().build(dependencies: .preview(items: []), router: AppRouter())
}
#endif
