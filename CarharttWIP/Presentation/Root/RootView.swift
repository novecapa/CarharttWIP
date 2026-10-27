//
//  RootView.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies
    @State private var router = AppRouter()

    var body: some View {
        SceneFactory(dependencies: dependencies, router: router).view(for: router.screen)
    }
}

#if DEBUG
#Preview {
    RootView(dependencies: .preview())
}
#endif
