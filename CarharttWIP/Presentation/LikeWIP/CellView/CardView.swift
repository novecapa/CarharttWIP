//
//  CardView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct CardView: View {
    let imageName: String

    var body: some View {
        // Reserve the available card area so image loading cannot move the controls.
        GeometryReader { geometry in
            AsyncImage(url: URL(string: imageName)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(.placeholder)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }
}
