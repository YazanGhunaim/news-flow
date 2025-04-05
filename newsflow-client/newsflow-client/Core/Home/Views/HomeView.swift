//
//  HomeView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct HomeView: View {
    var tokens: [String]?

    init() {
        tokens = KeychainManager.shared.getAllTokens()
    }

    var body: some View {
        VStack {
            ForEach(tokens ?? [], id: \.self) { token in
                Text(token)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
