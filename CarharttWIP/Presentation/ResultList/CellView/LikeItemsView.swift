//
//  LikeItemsView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct LikeItemsView: View {

    private enum Constants {
        static let iconLikeFrame: CGFloat = 30
        static let increaseHeightIn: CGFloat = 80
        static let likeIconSize: CGFloat = 14
        static let paddingH: CGFloat = 4
    }

    let item: LikeItem
    let frameSize: CGFloat

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.item.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameSize,
                           height: frameSize + Constants.increaseHeightIn)
            } placeholder: {
                Image(.placeholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameSize,
                           height: frameSize + Constants.increaseHeightIn)
                    .padding()
            }
            HStack {
                Text(item.item.title.capitalizingFirstLetter())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                Image(item.like.rawValue)
                    .resizable()
                    .frame(width: Constants.likeIconSize,
                           height: Constants.likeIconSize)
            }
            .frame(minHeight: Constants.iconLikeFrame)
            .frame(maxHeight: .infinity)
            .padding(.horizontal, Constants.paddingH)
            Spacer()
        }
    }
}
