//
//  ContentView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) private var authVM

    var body: some View {
        Group {
            switch authVM.userState {
            case .loggedOut:
                LoginView()
            case .loggedIn:
                TabBarView()
            default:
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}
