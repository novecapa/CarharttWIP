//
//  ItemView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct CardView: View {

    let imageName: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageName)) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFit()
                .padding()
        } placeholder: {
            Image(.placeholder)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}
