//
//  ContentView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct GameView: View {

    @State var showGameView: Bool = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Image(.wallpaper)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .padding(.all, 16)
                .clipped()
            
            Spacer().frame(height: 24)
            
            Text("Play and discover items for yourself".localized())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 16)
                .lineLimit(1)
                .font(.title3)
            
            Spacer().frame(height: 15)

            Text("React to 10 articles and access your recommendations. The game changes every day!".localized())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 16)
                .font(.caption)
            
            Spacer().frame(height: 40)
            
            Button {
                showGameView.toggle()
            } label: {
                Text("Start playing".localized())
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.black)
            .padding(.all, 16)
        }
        .fullScreenCover(isPresented: $showGameView, content: {
            LikeWIPViewBuilder().build()
        })
    }
}

#Preview {
    GameView()
}
