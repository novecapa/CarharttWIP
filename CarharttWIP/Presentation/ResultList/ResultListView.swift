//
//  ResultListView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct ResultListView: View {
    @State var viewModel: ResultListViewModel
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            if let toast = viewModel.state.toast {
                Text("Demo: \(toast.itemCount) articles selected. No order was placed.")
                    .font(.callout)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .foregroundStyle(.white)
                    .accessibilityIdentifier("results.toast")
            }
            HStack {
                Text("Final articles list (\(viewModel.likedItems.count)/\(viewModel.state.reactions.count))")
                    .font(.subheadline)
                    .accessibilityIdentifier("results.title")
                Spacer()
                Button {
                    viewModel.send(.closeTapped)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Play again")
                .accessibilityIdentifier("results.close")
            }
            .padding()
            if viewModel.likedItems.isEmpty {
                ContentUnavailableView("You don't have any items listed", systemImage: "heart.slash")
            } else {
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(viewModel.likedItems, id: \.item.id) { item in
                                LikeItemsView(item: item, frameSize: (geometry.size.width - 16) / 2)
                                    .contextMenu { reactionMenu(for: item) }
                            }
                        }
                    }
                }
                Button("Add to cart (demo)") { viewModel.send(.addToCartTapped) }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .foregroundStyle(.white)
                    .background(.black)
                    .padding()
                    .accessibilityIdentifier("results.addToCart")
            }
        }
        .task(id: viewModel.state.toast?.id) {
            guard let id = viewModel.state.toast?.id else { return }
            do { try await Task.sleep(for: .seconds(2.5)) } catch { return }
            viewModel.send(.toastExpired(id))
        }
    }

    @ViewBuilder
    private func reactionMenu(for entry: LikeItem) -> some View {
        if entry.like == .like {
            Button { change(entry, to: .superLike) } label: { Label("Superlike", image: .superLike) }
        } else {
            Button { change(entry, to: .like) } label: { Label("Like", image: .like) }
        }
        Button(role: .destructive) { change(entry, to: .disLike) } label: {
            Label("Delete from list", image: .disLike)
        }
    }

    private func change(_ entry: LikeItem, to reaction: LikeType) {
        viewModel.send(.changeReaction(itemID: entry.item.id, reaction: reaction))
    }
}

#if DEBUG
#Preview {
    ResultListViewBuilder().build(.mockItemsRandom, dependencies: .preview(), router: AppRouter())
}
#endif
