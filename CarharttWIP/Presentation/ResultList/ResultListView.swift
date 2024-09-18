//
//  ResultListView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct ResultListView: View {

    private enum Constants {
        // Fonts, Images
        static let toastHeight: CGFloat = 60
        static let closeIcon: String = "xmark"
        static let iconSize: CGFloat = 18
        static let alphaButtonClose: CGFloat = 0.8
        static let columnNumber: CGFloat = 2
        static let columnSpacing: CGFloat = 2
        static let buttonHeight: CGFloat = 44
    }

    @State var viewModel: ResultListViewModel
    @Environment(\.dismiss) var dismiss

    private let gridItems = Array(
        repeating: GridItem(.flexible(),
                            spacing: Constants.columnSpacing),
        count: Int(Constants.columnNumber)
    )

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isToast {
                    Text(viewModel.totalProductsAdded)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .frame(height: Constants.toastHeight)
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .foregroundColor(.white)
                }
                HStack {
                    Text(viewModel.titleText)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: Constants.closeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.iconSize,
                               height: Constants.iconSize)
                        .foregroundColor(.black).opacity(Constants.alphaButtonClose)
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                // Implementar listado productos con like y superlike
                GeometryReader { geometry in
                    let frameSize = geometry.size.width / Constants.columnNumber
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: gridItems,
                                  spacing: Constants.columnSpacing) {
                            ForEach(viewModel.likeItems, id: \.item.id) { item in
                                LikeItemsView(item: item, frameSize: frameSize)
                                    .contextMenu(ContextMenu(menuItems: {
                                        viewModel.likeMenuOptions(item)
                                    }))
                            }
                        }
                    }
                    .padding(.horizontal, Constants.columnSpacing)
                }
                if viewModel.showButtonAddCart {
                    Button(action: {
                        withAnimation {
                            viewModel.showAndHideToast()
                        }
                    }, label: {
                        Text("Add to cart".localized())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.buttonHeight)
                            .background(.black)
                            .padding()
                    })
                }
            }
            if viewModel.likeItems.isEmpty {
                Spacer()
                Text("You don't have any items listed".localized())
                    .font(.caption)
                Spacer()
            }
        }
    }
}

#Preview {
    ResultListViewBuilder().build(.mockItemsRandom)
}
