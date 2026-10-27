//
//  ContentView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

struct GameView: View {

    let onStart: () -> Void
    
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

            Text("React to 10 articles and access your recommendations. Start a new round whenever you like!".localized())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal], 16)
                .font(.caption)
            
            Spacer().frame(height: 40)
            
            Button {
                onStart()
            } label: {
                Text("Start playing".localized())
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.black)
            .accessibilityIdentifier("game.start")
            .padding(.all, 16)
        }

    }
}

#if DEBUG
#Preview {
    GameView(onStart: {})
}
#endif
