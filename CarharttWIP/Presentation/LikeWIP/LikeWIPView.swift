//
//  LikeWIPView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct LikeWIPView: View {

    private enum Constants {
        static let lockRotationDown: CGFloat = 25
        static let lockSwipeDown: CGFloat = 50
        // Fonts, Images
        static let closeIcon: String = "xmark"
        static let iconSize: CGFloat = 18
        static let productFontSize: CGFloat = 15
    }
    
    @State var viewModel: LikeWIPViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("Discover articles for you".localized())
                    .font(.subheadline)
                Spacer()
                Image(systemName: Constants.closeIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.iconSize,
                           height: Constants.iconSize)
                    .foregroundColor(.black)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding()
            ZStack {
                ForEach(viewModel.itemList.indices, id: \.self) { index in
                    let item = viewModel.itemList[index]
                    CardView(imageName: item.image)
                        .offset(x: viewModel.currentOffsetX(index),
                                y: viewModel.currentOffsetY(index))
                        .rotationEffect(viewModel.currentAngle(index))
                    .gesture(
                        index == viewModel.itemList.count - 1 ?
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.height > Constants.lockRotationDown {
                                    return
                                }
                                viewModel.showLikeIcon = false
                                viewModel.setRotation(gesture.translation)
                            }
                            .onEnded { gesture in
                                guard gesture.translation.height < Constants.lockSwipeDown else {
                                    viewModel.resetOffset()
                                    return
                                }
                                viewModel.setGestureSwipe(gesture.translation,
                                                          item: item,
                                                          index: index)
                            }
                        : nil
                    )
                    .animation(.easeInOut, value: viewModel.offset)
                }
                if viewModel.showLikeIcon {
                    viewModel.imageLikeResult
                }
                if viewModel.itemList.isEmpty {
                    ProgressView()
                }
            }
            VStack {
                Text(viewModel.productName)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: Constants.productFontSize))
                    .padding()
                Text(viewModel.reactionString)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.caption)
                    .padding(.top)
            }
            Spacer()
        }
        .onAppear {
            viewModel.resetData()
            viewModel.fetchData()
        }
        .fullScreenCover(isPresented: $viewModel.showProductList,
                         onDismiss: {
            viewModel.resetData()
            viewModel.fetchData()
        }, content: {
            ResultListViewBuilder().build(viewModel.finalItemList)
        })
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error".localized()),
                message: Text(viewModel.alertError),
                dismissButton: .default(
                    Text("OK".localized()),
                    action: {
                    viewModel.showAlert = false
                })
            )
        }
    }
}

#Preview {
    LikeWIPViewBuilder().build()
}
